import SwiftUI

@Observable
class AppSettings
{
    var sourceLanguage: String = UserDefaults.standard.string(forKey: "sourceLanguage") ?? "English"
    {
        didSet { UserDefaults.standard.set(sourceLanguage, forKey: "sourceLanguage") }
    }

    var targetLanguage: String = UserDefaults.standard.string(forKey: "targetLanguage") ?? "Czech"
    {
        didSet { UserDefaults.standard.set(targetLanguage, forKey: "targetLanguage") }
    }

    var translateUponPaste: Bool = UserDefaults.standard.bool(forKey: "translateUponPaste")
    {
        didSet { UserDefaults.standard.set(translateUponPaste, forKey: "translateUponPaste") }
    }
    
    var translateUponEnter: Bool = UserDefaults.standard.bool(forKey: "translateUponEnter")
    {
        didSet { UserDefaults.standard.set(translateUponEnter, forKey: "translateUponEnter") }
    }

    var translationStyleRaw: String = UserDefaults.standard.string(forKey: "translationStyle") ?? TranslationStyle.formal.rawValue
    {
        didSet { UserDefaults.standard.set(translationStyleRaw, forKey: "translationStyle") }
    }

    var lmStudioURL: String = UserDefaults.standard.string(forKey: "lmStudioURL") ?? "http://10.0.1.106:7001"
    {
        didSet { UserDefaults.standard.set(lmStudioURL, forKey: "lmStudioURL") }
    }

    var lmStudioModel: String = UserDefaults.standard.string(forKey: "lmStudioModel") ?? "google/gemma-3-12b"
    {
        didSet { UserDefaults.standard.set(lmStudioModel, forKey: "lmStudioModel") }
    }

    var translationStyle: TranslationStyle
    {
        get { TranslationStyle(rawValue: translationStyleRaw) ?? .formal }
        set { translationStyleRaw = newValue.rawValue }
    }

    let languages = [
        "English", "Czech", "Slovak", "Spanish", "French",
        "German", "Italian", "Portuguese", "Polish", "Russian",
        "Japanese", "Chinese", "Korean", "Arabic"
    ]

    static let isoCode: [String: String] = [
        "English": "en", "Czech": "cs", "Slovak": "sk",
        "Spanish": "es", "French": "fr", "German": "de",
        "Italian": "it", "Portuguese": "pt", "Polish": "pl",
        "Russian": "ru", "Japanese": "ja", "Chinese": "zh",
        "Korean": "ko", "Arabic": "ar"
    ]
}
