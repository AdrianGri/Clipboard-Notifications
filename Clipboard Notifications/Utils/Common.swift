//
//  Common.swift
//  Clipboard Notifications
//
//  Created by Adrian Gri on 2024-11-02.
//

import SwiftUI

class StateManager {
    static let shared = StateManager()
    
    var appDelegate: AppDelegate?
    
    private init() {}
}

func quit() {
    NSApplication.shared.terminate(nil)
}

func handleHover(hovering: Bool) {
    if hovering {
        NSCursor.pointingHand.push()
    } else {
        NSCursor.pop()
    }
}
