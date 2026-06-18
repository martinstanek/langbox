import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)
            Text("More options coming soon.")
                .foregroundStyle(.secondary)
        }
        .frame(width: 360, height: 200)
        .padding()
    }
}

#Preview {
    SettingsView()
}
