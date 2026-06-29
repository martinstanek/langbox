import SwiftUI

struct SettingsView: View
{
    private var appSettings: AppSettings = AppSettingsProvider.getSettings()
    
    var body: some View
    {
        Form
        {
            Section("LM Studio")
            {
                TextField("URL:", text: appSettings.$lmStudioURL)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
                TextField("Model:", text: appSettings.$lmStudioModel)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
            }

            Section("Behaviour")
            {
                Toggle("Translate upon paste", isOn: appSettings.$translateUponPaste)
                Text("Automatically translate whenever text is pasted into the source field.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Tone")
            {
                Picker("", selection: appSettings.translationStyle)
                {
                    ForEach(TranslationStyle.allCases, id: \.self)
                    {
                        Text($0.label).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                Text("Formal uses honorifics (Sie, vous, usted…). Informal uses familiar address (du, tu…).")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 360, height: 480)
    }
}

#Preview
{
    SettingsView()
}
