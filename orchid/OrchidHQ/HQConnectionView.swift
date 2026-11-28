import SwiftUI
import Foundation

struct HQConnectionView: View {
 @State private var endpoint = ""
 @State private var status = "Not connected"
 @State private var busy = false
 var body: some View {
  Form {
   Section("VaN HQ — ⚿") {
    TextField("HTTPS service base URL", text: $endpoint)
     .keyboardType(.URL).textInputAutocapitalization(.never).autocorrectionDisabled()
    Button("Check live HQ health") {
     guard let url = URL(string: endpoint), url.scheme == "https",
           url.host != nil, url.user == nil, url.password == nil,
           url.query == nil, url.fragment == nil else {
      status = "Enter a valid HTTPS service URL"; return
     }
     busy = true; status = "Checking…"
     Task { @MainActor in
      defer { busy = false }
      do {
       let health = try await HQClient(baseURL: url).checkHealth()
       status = "Server reports: \(health.service) / \(health.status). Authentication not verified."
      } catch { status = "Health check failed" }
     }
    }.disabled(busy)
    Text(status)
   }
   Section("Privacy") {
    Text("Keyboard remains offline. No typed text or credentials are submitted by this check.")
   }
  }.navigationTitle("ORCHID")
 }
}
