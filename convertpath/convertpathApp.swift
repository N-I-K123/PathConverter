import SwiftUI

@main
struct convertpathApp: App {
    @AppStorage("viewStatus") var isSimplifiedUI: Bool = false
       
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
                    CommandMenu("Widok") {
                        Toggle("Uproszczony UI", isOn: $isSimplifiedUI)
                            .keyboardShortcut("s", modifiers: [.command])
                }
        }
       
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
        @AppStorage("viewStatus") var isSimplifiedUI: Bool = false

        func applicationDidFinishLaunching(_ notification: Notification) {
            if let window = NSApplication.shared.windows.first {
                self.window = window
                updateWindowSize()  
            }
        }
        
        func updateWindowSize() {
            let simplifiedSize = NSSize(width: 100, height: 100)
            let fullSize = NSSize(width: 900, height: 400)

            if isSimplifiedUI {
                setWindowSize(simplifiedSize)
            } else {
                setWindowSize(fullSize)
            }
        }
        
        func setWindowSize(_ size: NSSize) {
            var frame = window.frame
            frame.size = size
            window.setFrame(frame, display: true, animate: true)

            window.minSize = size
            window.maxSize = size            
        }

}
