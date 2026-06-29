import Foundation

struct TranslationService
{
    func translate(text: String, from source: String, to target: String, style: TranslationStyle, baseURL: String, model: String) async throws -> String
    {
        guard let url = URL(string: "\(baseURL)/v1/chat/completions")
        else
        {
            throw TranslationError.invalidURL
        }

        let body = ChatRequest(
            model: model,
            messages: [
                .init(role: "system", content: style.systemPrompt(from: source, to: target)),
                .init(role: "user", content: text)
            ],
            temperature: 0.3
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200
        else
        {
            throw TranslationError.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)

        guard let content = decoded.choices.first?.message.content
        else
        {
            throw TranslationError.emptyResponse
        }

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
