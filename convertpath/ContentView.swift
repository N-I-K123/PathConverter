//
//  ContentView.swift
//  convertpath
//
//  Created by Krzysztof Żelazek on 17/04/2024.
//

import SwiftUI
import AppKit
import CxxStdlib




class ClipboardHelper {
    static func copyToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    static func pasteFromClipboard() -> String? {
            let pasteboard = NSPasteboard.general
            if let clipboardText = pasteboard.string(forType: .string) {
            let trimmedText = clipboardText.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmedText
            } else {
                return nil
        }
    }
}

struct ContentView: View {
    var appDelegate = AppDelegate()
    @AppStorage("viewStatus") var isSimplifiedUI: Bool = false
    var body: some View {
        VStack {
            if isSimplifiedUI {
                SimplifiedView()
                
            } else {
                FullView()
            }
        }
        .onChange(of: isSimplifiedUI) { newValue in
                    appDelegate.updateWindowSize()
                }
    }
}



struct SimplifiedView: View {

    @State private var text: String = ""
    @State private var convertedPath: String = ""
    @AppStorage("savedPrefix") var prefix: String = ""
    @AppStorage("isOwnPrefixEnabled")var ownPrefix: Bool = false
    @AppStorage("selectedSystem")var selectedSystem: Bool = false
    
    var body: some View {
        VStack{
            
        }
      
        
    }
}

struct FullView: View {
    @State private var text: String = ""
    @State private var convertedPath: String = ""
    @AppStorage("savedPrefix") var prefix: String = ""
    @AppStorage("isOwnPrefixEnabled")var ownPrefix: Bool = false
    @AppStorage("selectedSystem")var selectedSystem: Bool = false
    
    var body: some View {
        HStack {
            Spacer(minLength: 100)
            Text("Choose conversion destination system")
                .padding()
            Button(action: {
                self.selectedSystem = false
                setConversionDestination(selectedSystem);
            }) {
                Text("Windows - > \\")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background(!selectedSystem ? Color.blue.opacity(0.3) : Color.clear) // Podświetlenie wybranej opcji
            .cornerRadius(5)
            .padding(.trailing, 10)
            
            Button(action: {
                self.selectedSystem = true
                setConversionDestination(selectedSystem);
            }) {
                Text("Mac - > /")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background(selectedSystem ? Color.blue.opacity(0.3) : Color.clear) // Podświetlenie wybranej opcji
            .cornerRadius(5)
            
            Spacer(minLength: 300)
        }

        .padding()
        HStack{
            Spacer(minLength: 25)
            Toggle("own prefix", isOn: $ownPrefix)
                .padding()
                .toggleStyle(.switch)
                .onChange(of: ownPrefix) {
                    setPrefixStatus(ownPrefix);
                    }
            
            Spacer();
            TextField("insert prefix", text: $prefix)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(!ownPrefix)
                .onChange(of: prefix) {
                    setPrefix(std.string(prefix))
                    }
            Spacer(minLength: 25)
            
        }
        VStack {
            HStack{
                TextField("Insert path",  text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: text) {
                        engine(std.string(text))
                        convertedPath = String(getConvertedPath());
                        }
                    //.disabled(true)
                Button(action: {
                    text = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.005){
                        if let clipboardText = ClipboardHelper.pasteFromClipboard() {
                            let singleLineText = clipboardText.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
                            self.text = singleLineText
                        }
                    }
                }){
                    Image(systemName: "doc.on.clipboard") // Ikona przycisku wklejania
                        .padding()
                        .foregroundColor(.blue)
                    
                }
                Spacer(minLength: 17)
            }
                            
            HStack{
                Spacer()
                Text("Converted Path: ");
                Spacer()
                TextField("Converted", text: $convertedPath) // Dodanie pola tekstowego
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                Button(action: {
                    ClipboardHelper.copyToClipboard(text: self.convertedPath)
                            }) {
                                Image(systemName: "doc.on.doc") // Ikona przycisku kopiowania
                                    .padding()
                                    .foregroundColor(.blue)
                            }
                            .disabled(convertedPath.isEmpty)
                Spacer(minLength: 17)
            }
            
        }
        .padding()
        
    }
    init() {
            // Call the functions when the view is initialized
            setPrefixStatus(ownPrefix)
            setPrefix(std.string(prefix))
            setConversionDestination(selectedSystem)
        }
}


#Preview {
    ContentView()
}
