# Clipboard Notifications

A simple tool to send a notification when content is successfully copied to the clipboard with CMD + C. The tool is displayed in the menu bar with nothing but a quit button to close it.

## Usage

1. Build and run with Xcode
2. Allow accessbility permissions for the app under Settings > Privacy & Security > Accessibility
   - Required to capture CMD + C events
3. Allow notification permissions (should automatically be requested on first usage)

## How it works

The app monitors keydown events with `NSEvent.addGlobalMonitorForEvents(matching: .keyDown)` and waits for a CMD + C event. 
Once detected, the app polls the clipboard every 100ms for a clipboard change (waits for `NSPasteboard.general.changeCount` to change).
If no change is detected after 3s, polling stops.
