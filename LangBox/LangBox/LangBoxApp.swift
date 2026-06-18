import SwiftUI

@main
struct LangBoxApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No window scenes — the app lives entirely in the menu bar.
        // The empty Settings scene prevents a "no scene" runtime warning.
        Settings { EmptyView() }
    }
}
