//
//  GeneralSettingsView.swift
//  MyMacApp
//
//  Created by Richard Lam on 28/5/2024.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("host") private var host = DefaultValues.host
    @AppStorage("port") private var port = DefaultValues.port
    @AppStorage("timeoutRequest") private var timeoutRequest = DefaultValues.timeoutRequest
    @AppStorage("timeoutResource") private var timeoutResource = DefaultValues.timeoutResource
    
    @State private var hostEntry = DefaultValues.host
    @State private var portEntry = DefaultValues.port
    @State private var timeoutRequestEntry = DefaultValues.timeoutRequest
    @State private var timeoutResourceEntry = DefaultValues.timeoutResource

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            VStack{
                HStack{
                    TextField("Host IP:", text: $hostEntry)
                    TextField("Port:", text: $portEntry)
                        .onChange(of: port) {
                            let filtered = port.filter { "0123456789".contains($0) }
                            if filtered != port {
                                self.port = filtered
                            }
                        }
                }
                TextField("Request Timeout (in sec. Default 60):", text: $timeoutRequestEntry)
                    .onChange(of: timeoutRequestEntry) {
                        let filtered = timeoutRequestEntry.filter { "0123456789".contains($0) }
                        if filtered != timeoutRequestEntry {
                            self.timeoutRequestEntry = filtered
                        }
                    }
                
                TextField("Resources Timeout (in sec. Default: 604800):", text: $timeoutResourceEntry)
                    .onChange(of: timeoutResourceEntry) {
                        let filtered = timeoutResourceEntry.filter { "0123456789".contains($0) }
                        if filtered != timeoutResourceEntry {
                            self.timeoutResourceEntry = filtered
                        }
                    }
                
                HStack {
                        Button("OK") {
                            host = hostEntry
                            port = portEntry
                            timeoutRequest = timeoutRequestEntry
                            timeoutResource = timeoutResourceEntry
                          presentationMode.wrappedValue.dismiss() // Dismiss the popup
                        }
                        Button("Cancel") {
                          presentationMode.wrappedValue.dismiss() // Dismiss the popup
                        }
                      }
            }
        }
        .onAppear{
            hostEntry = host
            portEntry = port
            timeoutRequestEntry = timeoutRequest
            timeoutResourceEntry = timeoutResource
        }
        .padding()
        .frame(width: 550, height: 130)
    }
}

#Preview {
    GeneralSettingsView()
}
