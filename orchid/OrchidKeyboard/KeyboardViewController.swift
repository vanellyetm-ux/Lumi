import UIKit
// Keyboard has no network access. Only inserts explicitly tapped symbols.
final class KeyboardViewController: UIInputViewController {
 private let layout = UIStackView()
 override func viewDidLoad() {
  super.viewDidLoad()
  layout.axis = .vertical
  layout.spacing = 5
  layout.translatesAutoresizingMaskIntoConstraints = false
  view.addSubview(layout)
  NSLayoutConstraint.activate([
   layout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
   layout.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
   layout.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
   layout.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)])
  guard let url = Bundle.main.url(forResource: "orchid_symbols", withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let receiver = try? OrchidReceiver(data: data) else { return }
  let symbols = receiver.pack.symbols
  for offset in stride(from: 0, to: symbols.count, by: 6) {
    let row = UIStackView(); row.axis = .horizontal; row.spacing = 4; row.distribution = .fillEqually
    for entry in symbols[offset..<min(offset+6, symbols.count)] {
      let button = key(entry.symbol, action: #selector(insertSymbol(_:)))
      button.accessibilityLabel = entry.meaning
      row.addArrangedSubview(button)
    }
    layout.addArrangedSubview(row)
  }
  let controls = UIStackView(); controls.axis = .horizontal; controls.spacing = 5; controls.distribution = .fillEqually
  controls.addArrangedSubview(key("🌐", action: #selector(nextKeyboard)))
  controls.addArrangedSubview(key("space", action: #selector(space)))
  controls.addArrangedSubview(key("⌫", action: #selector(erase)))
  layout.addArrangedSubview(controls)
 }
 private func key(_ title: String, action: Selector) -> UIButton {
  let button = UIButton(type: .system)
  button.setTitle(title, for: .normal)
  button.backgroundColor = .secondarySystemBackground
  button.layer.cornerRadius = 7
  button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
  button.addTarget(self, action: action, for: .touchUpInside)
  return button
 }
 @objc private func insertSymbol(_ button: UIButton) { if let s = button.currentTitle { textDocumentProxy.insertText(s) } }
 @objc private func nextKeyboard() { advanceToNextInputMode() }
 @objc private func space() { textDocumentProxy.insertText(" ") }
 @objc private func erase() { textDocumentProxy.deleteBackward() }
}
