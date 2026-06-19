import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate
{
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification)
    {
        NSApp.setActivationPolicy(.accessory)

        popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button
        {
            button.image = NSImage(systemSymbolName: "translate", accessibilityDescription: "LangBox")
            button.action = #selector(handleClick)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    @objc private func handleClick(_ sender: NSStatusBarButton)
    {
        guard let event = NSApp.currentEvent else
        {
            return
        }
        if event.type == .rightMouseUp
        {
            showContextMenu()
        }
        else
        {
            togglePopover(sender)
        }
    }

    private func togglePopover(_ sender: NSStatusBarButton)
    {
        if popover.isShown
        {
            popover.performClose(nil)
        }
        else
        {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    private func showContextMenu()
    {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Settings …", action: #selector(showSettings), keyEquivalent: ","))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        // Temporarily assign the menu so the status item renders it, then clear it
        // so left-click still goes through handleClick next time.
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    @objc private func showAbout()
    {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }

    @objc private func showSettings()
    {
        if settingsWindow == nil
        {
            let controller = NSHostingController(rootView: SettingsView())
            let window = NSWindow(contentViewController: controller)
            window.title = "LangBox Settings"
            window.styleMask = [.titled, .closable]
            window.isReleasedWhenClosed = false
            window.setContentSize(NSSize(width: 360, height: 420))
            settingsWindow = window
        }
        
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow?.center()
        settingsWindow?.makeKeyAndOrderFront(nil)
    }
}
