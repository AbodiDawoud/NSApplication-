//
//  ContentView.swift
//  NSApplication++
    

import SwiftUI

struct NSApplicationDemo: View {
    let app = NSApplication.shared
    @State private var text = ""
    @State private var progressValue: Double = 10
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("NSApplication Private Extensions")
                    .foregroundStyle(Color.accentColor)
                
                HStack {
                    Button("Speak String", action: speak)
                    Button("Stop Speaking", action: app.stopSpeaking)
                }
                
                HStack {
                    Button("Start Dictation", action: app.startDictation)
                    Button("Stop Dictation", action: app.stopDictation)
                }
                
                HStack {
                    Button("ZoomAll", action: app.zoomAll)
                    Button("CloseAll", action: app.closeAll)
                }
                
                HStack {
                    Button("Show Exception", action: showExc)
                    Button("Open Feedback Assistant", action: app.openFeedbackAssistant)
                    Button("Show Guess Panel", action: app.showGuessPanel)
                    Button("Show Emoji Picker") { app.orderFrontCharacterPalette(nil) }
                }
                
                HStack {
                    Button("Accent Color") {
                        let red: Double = .random(in: 0...1)
                        let green: Double = .random(in: 0...1)
                        let blue: Double = .random(in: 0...1)
                        let randomColor = NSColor(Color(red: red, green: green, blue: blue))
                        app.setAccentColor(randomColor)
                    }
                    
                    Button("Toggle Appearance") {
                        if app.appearance == nil {
                            return app.setControlStripPaletteAppearance()
                        }
                        app.appearance = nil
                    }
                }
                
                Button("Display Progress Notification (Dock Icon)") {
                    progressValue += 5
                    app.displayProgressNotification(value: progressValue, isIndeterminate: true)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            TextEditor(text: $text)
        }
        .frame(minWidth: 550, minHeight: 400)
    }
    
    func speak() {
        let str = "I love working on macOS apps, it is so much fun to build something that can run on a Mac! I hope you enjoy this demo as much as I do."
        
        app.speakString(str)
    }
    
    func showExc() {
        let exc = NSException(
            name: .NSPPDIncludeNotFoundException,
            reason: "This is a test exception",
            userInfo: nil
        )
        
        app.showException(exc)
    }
}


extension NSApplication {
    func setControlStripPaletteAppearance() {
        self.appearance = NSAppearance.perform("_controlStripCustomizationPaletteAppearance").takeUnretainedValue() as! NSAppearance
    }
    
    func startDictation() {
        self.perform("startDictation:", with: nil)
    }
    
    func stopDictation() {
        self.perform("stopDictation:", with: nil)
    }
    
    func speakString(_ str: String) {
        self.perform("speakString:", with: str)
    }
    
    func stopSpeaking() {
        let isSpeaking = self.value(forKey: "isSpeaking") as! Bool
        if !isSpeaking { return print("Not speaking") }
        self.perform("stopSpeaking:", with: nil)
    }
    
    func setAccentColor(_ color: NSColor) {
        self.perform("_setAccentColor:", with: color)
    }
    
    func zoomAll() {
        self.perform("zoomAll:", with: nil)
    }
    
    func closeAll() {
        self.perform("closeAll:", with: nil)
    }
    
    func findWindowUsingWindowIdentifier(_ identifier: NSUserInterfaceItemIdentifier?) -> NSWindow? {
        self.perform("_findWindowUsingWindowIdentifier:", with: identifier).takeUnretainedValue() as? NSWindow
    }
    
    func displayProgressNotification(value: Double, isIndeterminate: Bool = false) {
        self.perform("_displayProgressNotification:isIndeterminate:", with: value, with: isIndeterminate)
    }
}

extension NSApplication {
    func showException(_ exception: NSException) {
        self.perform("_showException:", with: exception)
    }
    
    func openFeedbackAssistant() {
        self.perform("_openFeedbackAssistant:", with: nil)
    }
    
    func showPreferencesPanel() {
        self.perform("orderFrontPreferencesPanel:", with: nil)
    }
    
    func showGuessPanel() {
        self.perform("showGuessPanel:", with: nil)
    }
}


extension NSApplication {
    var accentColor: NSColor {
        self.value(forKey: "_accentColor") as! NSColor
    }
    
    var isNSDocumentBased: Bool {
        self.value(forKey: "_isNSDocumentBased") as! Bool
    }
    
    var hasNonMiniaturizedWindow: Bool {
        self.value(forKey: "_appHasNonMiniaturizedWindow") as! Bool
    }
    
    var hasOpenNSWindowOrPanel: Bool {
        self.value(forKey: "_appHasOpenNSWindowOrPanel") as! Bool
    }
    
    var hasVisibleWindowOrPanel: Bool {
        self.value(forKey: "_appHasVisibleWindowOrPanel") as! Bool
    }
    
    var currentAppIsViewService: Bool {
        self.value(forKey: "_currentAppIsViewService") as! Bool
    }
    
    var hiddenWindows: [NSWindow] {
        self.value(forKey: "_hiddenWindows") as? [NSWindow] ?? []
    }
    
    var previousKeyWindow: NSWindow? {
        self.value(forKey: "_previousKeyWindow") as? NSWindow
    }
    
    var publicPersistentUIInfo: NSDictionary {
        self.value(forKey: "_copyPublicPersistentUIInfo") as! NSDictionary
    }
}
