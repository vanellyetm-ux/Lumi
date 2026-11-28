import Foundation
struct OrchidSymbol: Codable, Identifiable {
 let symbol: String
 let shortcut: String
 let meaning: String
 let category: String
 var id: String { shortcut }
}
struct OrchidSymbolPack: Codable {
 let format: String
 let visibility: String
 let symbols: [OrchidSymbol]
}
struct OrchidInterpretation {
 let original: String
 let normalized: String
 let recognized: Bool
 let meaning: String?
 let executionAuthorized: Bool
}
enum OrchidError: Error { case format, duplicateSymbol, duplicateShortcut }
struct OrchidReceiver {
 let pack: OrchidSymbolPack
 private let bySymbol: [String: OrchidSymbol]
 private let byShortcut: [String: OrchidSymbol]
 init(data: Data) throws {
   let decoded = try JSONDecoder().decode(OrchidSymbolPack.self, from: data)
   guard decoded.format == "ORCHID_SYMBOL_PACK_V1" else { throw OrchidError.format }
   let symbols = Dictionary(decoded.symbols.map { ($0.symbol.precomposedStringWithCanonicalMapping, $0) }, uniquingKeysWith: { first, _ in first })
   let shortcuts = Dictionary(decoded.symbols.map { ($0.shortcut, $0) }, uniquingKeysWith: { first, _ in first })
   guard symbols.count == decoded.symbols.count else { throw OrchidError.duplicateSymbol }
   guard shortcuts.count == decoded.symbols.count else { throw OrchidError.duplicateShortcut }
   pack = decoded; bySymbol = symbols; byShortcut = shortcuts
 }
 func receive(_ input: String) -> OrchidInterpretation {
   let norm = input.precomposedStringWithCanonicalMapping
   let found = bySymbol[norm] ?? byShortcut[norm]
   return OrchidInterpretation(original: input, normalized: norm, recognized: found != nil, meaning: found?.meaning, executionAuthorized: false)
 }
 func expand(_ shortcut: String) -> String? { byShortcut[shortcut]?.symbol }
}
