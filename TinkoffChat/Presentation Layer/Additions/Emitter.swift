//
//  Emitter.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit
import Foundation

protocol Emitter {
    func startEmitting(with touch: UITouch)
    func updateEmittingPosition(with touch: UITouch)
    func stopEmitting()
}

class LogoEmitter: Emitter {
    private lazy var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterCells = [makeEmitterCells()]
        emitterLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        emitterLayer.birthRate = 0
        return emitterLayer
    }()
    private weak var window: UIWindow?
    
    init(_ window: UIWindow) {
        self.window = window
        window.layer.addSublayer(emitterLayer)
    }
    
    func startEmitting(with touch: UITouch) {
        emitterLayer.birthRate = 1
        updateEmittingPosition(with: touch)
    }
    
    func updateEmittingPosition(with touch: UITouch) {
        let location = touch.location(in: window)
        emitterLayer.emitterPosition = location
    }
    
    func stopEmitting() {
        emitterLayer.birthRate = 0
    }
    
    private func makeEmitterCells() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "logo").cgImage
        cell.emissionRange = .pi/2
        cell.emissionLongitude = .pi/2
        cell.emissionLatitude = .pi/2
        cell.alphaSpeed = -0.5
        cell.birthRate = 10
        cell.lifetime = 1
        cell.lifetimeRange = 0.5
        cell.velocity = 40
        cell.velocityRange = 40
        cell.spin = .pi
        cell.spinRange = .pi/2
        cell.scale = 0.2
        cell.scaleRange = 0.05
        return cell
    }
}
