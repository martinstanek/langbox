import SwiftUI

struct SettingsView: View
{
    @Environment(AppSettings.self) private var appSettings

    var body: some View
    {
        @Bindable var settings = appSettings
        Form
        {
            Section("LM Studio")
            {
                TextField("URL:", text: $settings.lmStudioURL)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
                TextField("Model:", text: $settings.lmStudioModel)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
                Picker("", selection: $settings.modelFamily)
                {
                    ForEach(ModelFamily.allCases, id: \.self)
                    {
                        Text($0.label).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                Text("Generic works with any instruction-tuned model. Translation uses a structured format required by models like TranslateGemma — check your model's documentation if unsure.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Behaviour")
            {
                Toggle("Translate upon paste", isOn: $settings.translateUponPaste)
                Text("Automatically translate whenever text is pasted into the source field.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Toggle("Translate upon enter", isOn: $settings.translateUponEnter)
                Text("Automatically translate whenever enter is pressed in the input field.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Tone")
            {
                Picker("", selection: $settings.translationStyle)
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
        .frame(width: 360, height: 600)
    }
}

#Preview
{
    SettingsView()
        .environment(AppSettings())
}
