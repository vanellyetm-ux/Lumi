import Foundation
// Host-app-only bridge. URL must be configured from a real deployed HTTPS HQ service.
struct HQClient {
 struct Health: Decodable { let service: String; let status: String }
 let baseURL: URL
 func checkHealth() async throws -> Health {
  guard baseURL.scheme == "https" else { throw URLError(.unsupportedURL) }
  var req = URLRequest(url: baseURL.appendingPathComponent("health"))
  req.httpMethod = "GET"; req.timeoutInterval = 10
  let (data, response) = try await URLSession.shared.data(for: req)
  guard let http = response as? HTTPURLResponse, http.statusCode == 200 else { throw URLError(.badServerResponse) }
  return try JSONDecoder().decode(Health.self, from: data)
 }
}
