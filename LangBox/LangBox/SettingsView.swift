import SwiftUI

struct SettingsView: View
{
    @AppStorage("translateUponPaste") private var translateUponPaste = false
    @AppStorage("translationStyle") private var translationStyleRaw = TranslationStyle.formal.rawValue
    @AppStorage("lmStudioURL") private var lmStudioURL = "http://10.0.1.106:7001"
    @AppStorage("lmStudioModel") private var lmStudioModel = "google/gemma-3-12b"

    private var translationStyle: Binding<TranslationStyle>
    {
        Binding(
            get: { TranslationStyle(rawValue: translationStyleRaw) ?? .formal },
            set: { translationStyleRaw = $0.rawValue })
    }

    var body: some View
    {
        Form
        {
            Section("LM Studio")
            {
                TextField("URL:", text: $lmStudioURL)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
                TextField("Model:", text: $lmStudioModel)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
            }

            Section("Behaviour")
            {
                Toggle("Translate upon paste", isOn: $translateUponPaste)
                Text("Automatically translate whenever text is pasted into the source field.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Tone")
            {
                Picker("", selection: translationStyle)
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
