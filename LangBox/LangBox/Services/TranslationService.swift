import Foundation

struct TranslationService
{
    func translate(
        text: String,
        from source: String,
        to target: String,
        style: TranslationStyle,
        baseURL: String,
        model: String,
        modelFamily: ModelFamily) async throws -> String
    {
        switch modelFamily
        {
        case .translation:
            return try await translateWithGemma(text: text, from: source, to: target, baseURL: baseURL, model: model)
        case .generic:
            return try await translateWithChat(text: text, from: source, to: target, style: style, baseURL: baseURL, model: model)
        }
    }

    // MARK: - Standard chat completions

    private func translateWithChat(
        text: String,
        from source: String,
        to target: String,
        style: TranslationStyle,
        baseURL: String,
        model: String) async throws -> String
    {
        guard let url = URL(string: "\(baseURL)/v1/chat/completions") else { throw TranslationError.invalidURL }

        let body = ChatRequest(
            model: model,
            messages: [
                .init(role: "system", content: style.systemPrompt(from: source, to: target)),
                .init(role: "user", content: text)
            ],
            temperature: 0.3
        )

        let data = try await post(url: url, body: body)
        let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)

        guard let content = decoded.choices.first?.message.content else { throw TranslationError.emptyResponse }
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - TranslateGemma via raw completions

    private func translateWithGemma(
        text: String,
        from source: String,
        to target: String,
        baseURL: String,
        model: String) async throws -> String
    {
        guard let url = URL(string: "\(baseURL)/v1/completions") else { throw TranslationError.invalidURL }

        let sourceCode = AppSettings.isoCode[source] ?? source.lowercased()
        let targetCode = AppSettings.isoCode[target] ?? target.lowercased()

        let payload = [["type": "text", "source_lang_code": sourceCode, "target_lang_code": targetCode, "text": text]]
        let payloadJSON = (try? String(data: JSONEncoder().encode(payload), encoding: .utf8)) ?? text

        // Gemma instruct prompt template
        let prompt = "<bos><start_of_turn>user\n\(payloadJSON)<end_of_turn>\n<start_of_turn>model\n"

        let body = CompletionRequest(model: model, prompt: prompt, temperature: 0.3)
        let data = try await post(url: url, body: body)
        let decoded = try JSONDecoder().decode(CompletionResponse.self, from: data)

        guard let raw = decoded.choices.first?.text else { throw TranslationError.emptyResponse }
        return try extractGemmaTranslation(from: raw)
    }

    // MARK: - HTTP

    private func post(url: URL, body: some Encodable) async throws -> Data
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200
        else { throw TranslationError.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1) }

        return data
    }

    // MARK: - TranslateGemma response parsing

    private func extractGemmaTranslation(from raw: String) throws -> String
    {
        // Strip optional markdown code fences
        let stripped = raw
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Happy path: model returned the expected JSON array
        if let data = stripped.data(using: .utf8),
           let array = try? JSONDecoder().decode([[String: String]].self, from: data),
           let translated = array.first?["text"]
        {
            return translated.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Fallback: model returned plain text (happens with ambiguous inputs)
        let fallback = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !fallback.isEmpty else { throw TranslationError.emptyResponse }
        return fallback
    }
}
