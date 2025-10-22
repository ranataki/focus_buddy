//
//  FloatingTimerWindow.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//
import SwiftUI
import AppKit

final class FloatingTimerWindowController: NSObject, NSWindowDelegate {
    static let shared = FloatingTimerWindowController()
    private var panel: NSPanel?
    private var host: NSHostingController<AnyView>?

    func toggle(vm: FocusTimerViewModel) {
        if panel == nil { createWindow(vm: vm) }
        if panel?.isVisible == true { hide() } else { show() }
    }

    func reloadAppearance(vm: FocusTimerViewModel) {
        // simplest: rebuild with new appearance if visible
        let wasVisible = (panel?.isVisible == true)
        if wasVisible { hide() }
        destroy()
        if wasVisible { createWindow(vm: vm); show() }
    }

    private func createWindow(vm: FocusTimerViewModel) {
        let screen = NSScreen.main?.visibleFrame ?? .init(x: 200, y: 200, width: 800, height: 600)
        let size = NSSize(width: 260, height: 160)
        let origin = NSPoint(x: screen.maxX - size.width - 30, y: screen.maxY - size.height - 140)

        let panel = NSPanel(
            contentRect: .init(origin: origin, size: size),
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        panel.hidesOnDeactivate = false
        panel.isMovableByWindowBackground = true
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true

        // Apply appearance
        switch vm.appearance {
        case .system: panel.appearance = nil
        case .light:  panel.appearance = NSAppearance(named: .aqua)
        case .dark:   panel.appearance = NSAppearance(named: .darkAqua)
        }

        let root = AnyView(FloatingTimerView().environmentObject(vm))
        let host = NSHostingController(rootView: root)
        panel.contentViewController = host

        self.panel = panel
        self.host = host
    }

    private func show() { panel?.orderFrontRegardless() }
    private func hide() { panel?.orderOut(nil) }
    private func destroy() { panel = nil; host = nil }
}
