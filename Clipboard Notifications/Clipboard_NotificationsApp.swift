//
//  Clipboard_NotificationsApp.swift
//  Clipboard Notifications
//
//  Created by Adrian Gri on 2024-09-25.
//

import SwiftUI

@main
struct Clipboard_NotificationsApp: App {
    var body: some Scene {
        MenuBarExtra("Clipboard Notifications", image: "MenuBarIcon") {
            MenuBarMenu()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    @Published var userId: String?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        StateManager.shared.appDelegate = self
        
        let clipboardMonitor = ClipboardMonitor()
        clipboardMonitor.startMonitoring()
    }
}
