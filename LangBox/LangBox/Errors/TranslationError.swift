import Foundation

enum TranslationError: LocalizedError
{
    case invalidURL
    case badResponse(Int)
    case emptyResponse

    var errorDescription: String?
    {
        switch self
        {
            case .invalidURL:       
                return "Invalid server URL."
            case .badResponse(let code): 
                return "Server returned status \(code)."
            case .emptyResponse:    
                return "Model returned an empty response."
        }
    }
}
