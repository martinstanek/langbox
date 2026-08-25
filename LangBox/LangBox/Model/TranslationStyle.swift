import Foundation

public enum TranslationStyle: String, CaseIterable
{
    case formal
    case informal

    var label: String
    {
        switch self
        {
            case .formal:   
                return "Formal"
            case .informal: 
                return "Informal"
        }
    }

    func systemPrompt(from source: String, to target: String) -> String
    {
        let register: String
        switch self
        {
            case .formal:
                register = "Use formal language and appropriate honorifics (e.g. Sie in German, vous in French, Lei in Italian, usted in Spanish)."
            case .informal:
                register = "Use informal, conversational language (e.g. du in German, tu in French/Spanish/Italian)."
        }
        return "You are a translation assistant. Translate the text from \(source) to \(target). \(register) Return only the translated text, no explanations."
    }
}
