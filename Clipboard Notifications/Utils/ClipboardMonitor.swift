//
//  ClipboardMonitor.swift
//  Clipboard Notifications 2
//
//  Created by Adrian Gri on 2024-09-25.
//

import Cocoa
import UserNotifications
import Combine

class ClipboardMonitor: ObservableObject {
    private var count: Int?
    private var clipboardPollingTimer: Timer?
    
    init() {
        requestNotificationPermission()
        checkAccessibilityPermission()
    }

    func startMonitoring() {
        DispatchQueue.global(qos: .background).async {
            self.monitorCopyCommand()
        }
    }

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    private func checkAccessibilityPermission() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            print("Accessibility permission is not enabled. Please enable it in System Preferences.")
            openSystemPreferences()
        } else {
            print("Accessibility permission is enabled.")
        }
    }

    private func openSystemPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }

    private func monitorCopyCommand() {
        print("Monitoring started...")
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) && event.charactersIgnoringModifiers == "c" {
                print("Cmd + C detected")
                self.startClipboardPolling()
            }
        }
    }

    private func startClipboardPolling() {
        // Stop any existing polling
        clipboardPollingTimer?.invalidate()
        
        // Set up a polling timer
        clipboardPollingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            print("polling")
            self?.checkClipboardChange()
        }
        
        // Schedule to stop polling after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.stopClipboardPolling()
        }
    }

    private func stopClipboardPolling() {
        clipboardPollingTimer?.invalidate()
        clipboardPollingTimer = nil
        print("Stopped polling after 3 seconds")
    }

    private func checkClipboardChange() {
        let pasteboard = NSPasteboard.general
        print("items", pasteboard.changeCount)
        
        if pasteboard.changeCount != count {
            count = pasteboard.changeCount
            var numCharacters = 0
            
            if let copiedText = pasteboard.string(forType: .string) {
                numCharacters = copiedText.lengthOfBytes(using: .utf8)
            }
            
            runCustomAction(with: numCharacters)
            stopClipboardPolling()
        }
    }

    private func runCustomAction(with length: Int) {
        print("Running custom action after copy")
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = length != 0 ? "Copied \(length) Characters" : "Copied Item(s)"
        content.body = length != 0 ? "Copied \(length) characters to clipboard." : "Copied item(s) to clipboard."
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        center.add(request)
    }
}
