import SwiftUI

struct SettingsView: View {
    @AppStorage("translateUponPaste") private var translateUponPaste = false

    var body: some View {
        Form {
            Section {
                Toggle("Translate upon paste", isOn: $translateUponPaste)
                Text("Automatically translate whenever text is pasted into the source field.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 360, height: 160)
    }
}

#Preview {
    SettingsView()
}
