import SwiftUI

public struct AppSettings
{
    @AppStorage("translateUponPaste") public var translateUponPaste = false
    @AppStorage("translationStyle") public var translationStyleRaw = TranslationStyle.formal.rawValue
    @AppStorage("lmStudioURL") public var lmStudioURL = "http://10.0.1.106:7001"
    @AppStorage("lmStudioModel") public var lmStudioModel = "google/gemma-3-12b"
    @AppStorage("sourceLanguage") public var sourceLanguage = "English"
    @AppStorage("targetLanguage") public var targetLanguage = "Czech"
    
    public var translationStyle: Binding<TranslationStyle>
    {
        Binding(
            get: { TranslationStyle(rawValue: translationStyleRaw) ?? .formal },
            set: { translationStyleRaw = $0.rawValue })
    }
}

public class AppSettingsProvider
{
    private static var settings: AppSettings?
    
    public static func getSettings() -> AppSettings
    {
        if (settings == nil)
        {
            settings = AppSettings()
        }
        
        return settings!
    }
}
