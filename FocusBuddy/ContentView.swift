//
//  ContentView.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//

import SwiftUI
import Combine
import UserNotifications
import AppKit

struct ContentView: View {
    @EnvironmentObject var vm: FocusTimerViewModel
    @State private var customMinutes: String = ""

    var body: some View {
        let pal = themeColors(vm.color, vm.appearance)
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text(vm.menuBarTitle)
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                Text(vm.isRunning ? "Focusing…" : "Paused")
                    .font(.subheadline).foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                Button(vm.isRunning ? "Pause" : "Start") { vm.toggle() }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(pal.accent)
                Button("Reset") { vm.stop() }
                    .buttonStyle(.bordered)
                    .tint(pal.accent)
            }

            Divider()
            HStack(alignment: .firstTextBaseline) {
                Text("Presets").font(.caption).foregroundStyle(.secondary)
                Spacer()
                // Unified Theme dropdown (Color + Appearance)
                Menu("Theme") {
                    Section("Color") {
                        ForEach(FocusTimerViewModel.ColorTheme.allCases) { c in
                            Button(action: { vm.setColor(c) }) {
                                HStack { Text(c.rawValue.capitalized); if vm.color == c { Spacer(); Image(systemName: "checkmark") } }
                            }
                        }
                    }
                    Section("Appearance") {
                        ForEach(FocusTimerViewModel.Theme.allCases) { a in
                            Button(action: {
                                vm.setTheme(a)
                                // Live refresh HUD by reconstructing it (simple + reliable)
                                FloatingTimerWindowController.shared.reloadAppearance(vm: vm)
                            }) {
                                HStack { Text(a.rawValue.capitalized); if vm.appearance == a { Spacer(); Image(systemName: "checkmark") } }
                            }
                        }
                    }
                }
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: 8)]) {
                ForEach(FocusTimerViewModel.Preset.allCases) { preset in
                    PresetChip(preset: preset)
                }
            }

            Divider()
            HStack {
                TextField("Custom min", text: $customMinutes)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onSubmit(setCustom)
                Button("Set") { setCustom() }
            }

            Divider()
            HStack {
                Button("Show Floating Panel") { FloatingTimerWindowController.shared.toggle(vm: vm) }
                Spacer()
                Text("Space: Start/Pause  •  R: Reset")
                    .font(.caption2).foregroundStyle(.secondary)
            }
        }
    }

    private func setCustom() {
        guard let mins = Int(customMinutes), mins > 0 else { return }
        vm.reset(to: .pomo)
        vm.remaining = mins * 60
        vm.pause()
    }
}
