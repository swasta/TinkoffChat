//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 19/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import MultipeerConnectivity

class MultipeerCommunicator: NSObject {
    
    enum MultipeerCommunicatorError: Error {
        case communicatorInternalError
        case communicatorMessageEncodingError
    }
    
    weak var delegate: ICommunicatorDelegate?
    
    private let serviceType = "tinkoff-chat"
    private let discoveryInfoUserNameKey = "userName"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    private let serviceBrowser: MCNearbyServiceBrowser
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let messageHandler: IMessageHandler
    
    private var sessionsByPeerID = [MCPeerID: MCSession]()
    private var foundPeers = [MCPeerID: [String: String]?]()
    private var connectedPeers = Set<MCPeerID>()
    
    init(_ messageHandler: IMessageHandler) {
        self.messageHandler = messageHandler
        let discoveryInfo = [discoveryInfoUserNameKey: UIDevice.current.name]
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        super.init()
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
        startServices()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    // MARK: Private methods
    
    private func startServices() {
        serviceBrowser.startBrowsingForPeers()
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    private func getSessionFor(_ peer: MCPeerID) -> MCSession? {
        return sessionsByPeerID[peer]
    }
    
    private func createNewSession(for peer: MCPeerID) -> MCSession {
        print("creating new session with \(peer.displayName)")
        let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessionsByPeerID[peer] = session
        return session
    }
    
    private func getPeerIDFor(_ userID: String) -> MCPeerID? {
        return sessionsByPeerID.keys.filter { $0.displayName == userID }.first
    }
}

// MARK: ICommunicator

extension MultipeerCommunicator: ICommunicator {
    func sendMessage(text: String, to userID: String) throws {
        guard let peerID = getPeerIDFor(userID), let session = sessionsByPeerID[peerID] else {
            throw MultipeerCommunicatorError.communicatorInternalError
        }
        guard let serializedMessage = messageHandler.prepareForSend(text: text) else {
            throw MultipeerCommunicatorError.communicatorMessageEncodingError
        }
        do {
            try session.send(serializedMessage, toPeers: [peerID], with: .reliable)
        } catch {
            print("Failed to send message \(error)")
        }
    }
}

// MARK: - MCNearbyServiceBrowserDelegate

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    private static let peerInvitationTimeout: TimeInterval = 30
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        print("found peer \(peerID.displayName)")
        foundPeers[peerID] = info
        let session = getSessionFor(peerID) ?? createNewSession(for: peerID)
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: MultipeerCommunicator.peerInvitationTimeout)
        print("invited peer \(peerID.displayName)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost \(peerID.displayName)")
        if connectedPeers.remove(peerID) != nil {
            delegate?.didLoseUser(userID: peerID.displayName)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
}

// MARK: MCNearbyServiceAdvertiserDelegate

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("did receive invitation from \(peerID.displayName)")
        let session = getSessionFor(peerID) ?? createNewSession(for: peerID)
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
}

// MARK: MCSessionDelegate

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = messageHandler.getMessage(from: data) else {
            print("Couldn't decode message from \(peerID.displayName)")
            return
        }
        if connectedPeers.contains(peerID) {
            delegate?.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: myPeerID.displayName)
        } else {
            print("Received message from not connected peer ¯\\_(ツ)_/¯")
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("state connected")
            if let peerDiscoveryInfo = foundPeers[peerID] {
                print("connected with \(peerID.displayName)")
                delegate?.didFindUser(userID: peerID.displayName, userName: peerDiscoveryInfo?[discoveryInfoUserNameKey])
                connectedPeers.insert(peerID)
            }
        case .notConnected:
            print("not connected with \(peerID.displayName)")
            if connectedPeers.remove(peerID) != nil {
                delegate?.didLoseUser(userID: peerID.displayName)
            }
            sessionsByPeerID.removeValue(forKey: peerID)
            foundPeers.removeValue(forKey: peerID)
            session.disconnect()
        case .connecting:
            print("connecting state with \(peerID.displayName)")
        }
        
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
}
