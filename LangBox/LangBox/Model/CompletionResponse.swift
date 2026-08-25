import Foundation

struct CompletionResponse: Decodable
{
    let choices: [Choice]

    struct Choice: Decodable
    {
        let text: String
    }
}
