//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 19/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import MultipeerConnectivity

class MultipeerCommunicator: NSObject {
    weak var delegate: CommunicatorDelegate?
    var online = false
    
    private let serviceType = "tinkoff-chat"
    private let discoveryInfoUserNameKey = "userName"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    
    private var serviceBrowser: MCNearbyServiceBrowser
    private var serviceAdvertiser: MCNearbyServiceAdvertiser
    private var messageSerializer: MessageSerializer
    private var sessionsByPeerID = [MCPeerID: MCSession]()
    private var invitedPeers = [MCPeerID: [String: String]?]()
    
    init(with serializer: MessageSerializer) {
        messageSerializer = serializer
        let discoveryInfo = [discoveryInfoUserNameKey: UIDevice.current.name]
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        super.init()
        setup()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    private func setup() {
        serviceBrowser.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.startBrowsingForPeers()
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    private func getSessionFor(_ peer: MCPeerID) -> MCSession {
        if let session = sessionsByPeerID[peer] {
            return session
        }
        let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessionsByPeerID[peer] = session
        return session
    }
    
    private func getPeerIDFor(_ userID: String) -> MCPeerID? {
        return sessionsByPeerID.keys.filter { $0.displayName == userID }.first
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    private static let peerInvitationTimeout: TimeInterval = 30
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let session = getSessionFor(peerID)
        if !session.connectedPeers.contains(peerID) {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: MultipeerCommunicator.peerInvitationTimeout)
            invitedPeers[peerID] = info
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        sessionsByPeerID.removeValue(forKey: peerID)
        delegate?.didLoseUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let session = getSessionFor(peerID)
        let shouldAcceptInvitation = !session.connectedPeers.contains(peerID)
        invitationHandler(shouldAcceptInvitation, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
}

extension MultipeerCommunicator: Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        guard let peerID = getPeerIDFor(userID) else {
            return
        }
        let session = sessionsByPeerID[peerID]
        do {
            let serializedMessage = try messageSerializer.serializeMessageWith(string)
            try session?.send(serializedMessage, toPeers: [peerID], with: .reliable)
            completionHandler?(true, nil)
        } catch {
            completionHandler?(false, error)
        }
    }
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            if let message = try messageSerializer.deserializeMessageFrom(data) {
                delegate?.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: myPeerID.displayName)
            }
        } catch {
            print("\(error)")
        }
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if let peerDiscoveryInfo = invitedPeers[peerID], state == .connected {
            delegate?.didFindUser(userID: peerID.displayName, userName: peerDiscoveryInfo?[discoveryInfoUserNameKey])
            invitedPeers.removeValue(forKey: peerID)
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
}
