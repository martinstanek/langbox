import SwiftUI

struct ContentView: View
{
    private var appSettings: AppSettings = AppSettingsProvider.getSettings()
    
    @State private var inputText = ""
    @State private var outputText = ""
    @State private var isTranslating = false
    @State private var errorMessage: String?
    
    private var service = TranslationService()

    private let languages =
    [
        "English", "Czech", "Slovak", "Spanish", "French",
        "German", "Italian", "Portuguese", "Polish", "Russian",
        "Japanese", "Chinese", "Korean", "Arabic"
    ]

    var body: some View
    {
        VStack(spacing: 0)
        {
            languageBar
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background.secondary)

            Divider()

            VStack(spacing: 10)
            {
                textPanel(
                    label: "Source",
                    text: $inputText,
                    trailingButton: {
                        clipboardButton(icon: "clipboard", help: "Paste from clipboard") {
                            inputText = NSPasteboard.general.string(forType: .string) ?? ""
                            if appSettings.translateUponPaste { Task { await translate() } }
                        }
                    }
                )

                translateButton

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                textPanel(
                    label: "Translation",
                    text: $outputText,
                    trailingButton: {
                        clipboardButton(icon: "doc.on.doc", help: "Copy to clipboard") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(outputText, forType: .string)
                        }
                        .disabled(outputText.isEmpty)
                    }
                )
            }
            .padding(16)

            Divider()

            quitBar
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.background.secondary)
        }
        .frame(width: 460)
    }

    // MARK: - Language Bar

    private var languageBar: some View {
        HStack(spacing: 8) {
            Picker("", selection: appSettings.$sourceLanguage) {
                ForEach(languages, id: \.self) { Text($0) }
            }
            .labelsHidden()
            .frame(maxWidth: .infinity)

            Button {
                swap(&appSettings.sourceLanguage, &appSettings.targetLanguage)
                swap(&inputText, &outputText)
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .fontWeight(.medium)
            }
            .buttonStyle(.plain)
            .help("Swap languages")

            Picker("", selection: appSettings.$targetLanguage) {
                ForEach(languages, id: \.self) { Text($0) }
            }
            .labelsHidden()
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Text Panels

    private func textPanel<Trailing: View>(
        label: String,
        text: Binding<String>,
        @ViewBuilder trailingButton: () -> Trailing
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                Spacer()
                trailingButton()
            }
            TextEditor(text: text)
                .font(.body)
                .frame(height: 110)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.background)
                        .stroke(.separator, lineWidth: 0.5)
                )
        }
    }

    // MARK: - Translate Button

    private var translateButton: some View {
        Button {
            Task { await translate() }
        } label: {
            Group {
                if isTranslating {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                        .tint(.white)
                } else {
                    Label("Translate", systemImage: "wand.and.sparkles")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .keyboardShortcut(.return, modifiers: .command)
        .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isTranslating)
    }

    private func translate() async {
        errorMessage = nil
        isTranslating = true
        defer { isTranslating = false }
        do {
            outputText = try await service.translate(
                text: inputText,
                from: appSettings.sourceLanguage,
                to: appSettings.targetLanguage,
                style: appSettings.translationStyle.wrappedValue
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Quit Bar

    private var quitBar: some View {
        HStack {
            Button("Clear") {
                inputText = ""
                outputText = ""
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundStyle(.tertiary)
            .disabled(inputText.isEmpty && outputText.isEmpty)
            Spacer()
            Button("Quit LangBox") {
                NSApp.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundStyle(.tertiary)
        }
    }

    // MARK: - Helpers

    private func clipboardButton(icon: String, help: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .help(help)
    }
}

#Preview {
    ContentView()
}
