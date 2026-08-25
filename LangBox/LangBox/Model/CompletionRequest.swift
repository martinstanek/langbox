import Foundation

struct CompletionRequest: Encodable
{
    let model: String
    let prompt: String
    let temperature: Double
}
