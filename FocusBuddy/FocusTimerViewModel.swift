//
//  FocusTimerViewModel.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//

import SwiftUI
import Combine
import UserNotifications
import AppKit

final class FocusTimerViewModel: ObservableObject {
    // Timer state
    @Published var remaining: Int = 25 * 60
    @Published var isRunning: Bool = false
    @Published var selectedPreset: Preset = .pomo

    // Appearance model
    enum ColorTheme: String, CaseIterable, Identifiable { case mint, sunset, electric, graphite; var id: String { rawValue } }
    enum Theme: String, CaseIterable, Identifiable { case system, light, dark; var id: String { rawValue } }

    @AppStorage("focusbuddy_color") var colorRaw: String = ColorTheme.sunset.rawValue
    @AppStorage("focusbuddy_theme") var themeRaw: String = Theme.light.rawValue

    var color: ColorTheme { ColorTheme(rawValue: colorRaw) ?? .sunset }
    var appearance: Theme { Theme(rawValue: themeRaw) ?? .light }
    func setColor(_ c: ColorTheme) { colorRaw = c.rawValue }
    func setTheme(_ t: Theme) { themeRaw = t.rawValue }

    private var cancellable: AnyCancellable?

    enum Preset: Int, CaseIterable, Identifiable {
        case quick5 = 300, short10 = 600, focus15 = 900, focus20 = 1200, pomo = 1500, deep45 = 2700, hour = 3600
        var id: Int { rawValue }
        var label: String {
            switch self {
            case .quick5: return "5m"; case .short10: return "10m"; case .focus15: return "15m";
            case .focus20: return "20m"; case .pomo: return "25m"; case .deep45: return "45m"; case .hour: return "60m" }
        }
    }

    var menuBarTitle: String { format(remaining) }

    func start(preset: Preset? = nil) {
        if let p = preset { selectedPreset = p; remaining = p.rawValue }
        guard !isRunning else { return }
        isRunning = true
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remaining > 0 { self.remaining -= 1 } else { self.stop(); self.fireComplete() }
            }
    }

    func toggle() { isRunning ? pause() : start() }
    func pause() { isRunning = false; cancellable?.cancel() }
    func stop() { isRunning = false; cancellable?.cancel(); remaining = selectedPreset.rawValue }
    func reset(to preset: Preset) { pause(); selectedPreset = preset; remaining = preset.rawValue }

    private func fireComplete() {
        NSSound(named: NSSound.Name("Glass"))?.play()
        let content = UNMutableNotificationContent()
        content.title = "Time's up!"
        content.body = "Great session — take a breather 💫"
        content.sound = .default
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil))
    }

    private func format(_ s: Int) -> String { String(format: "%02d:%02d", s/60, s%60) }
}
