import Foundation

public struct ChatRequest: Encodable
{
    let model: String
    let messages: [Message]
    let temperature: Double

    struct Message: Encodable
    {
        let role: String
        let content: String
    }
}
