//
//  EmittingWindow.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class EmittingWindow: UIWindow {
    private var emmiter: Emitter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        emmiter = LogoEmitter(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(_ event: UIEvent) {
        if event.type == .touches, let touches = event.allTouches {
            for touch in touches {
                switch touch.phase {
                case .began:
                    emmiter.startEmitting(with: touch)
                case .moved:
                    emmiter.updateEmittingPosition(with: touch)
                case .ended, .cancelled:
                    emmiter.stopEmitting()
                default:
                    break
                }
            }
        }
        super.sendEvent(event)
    }
}
