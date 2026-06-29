public enum ModelFamily: String, CaseIterable
{
    case generic
    case translation

    var label: String
    {
        switch self
        {
            case .generic:
                return "Generic"
            case .translation: 
                return "Translation"
        }
    }
}
