//
//  PresetChip.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//

import SwiftUI
import Combine
import UserNotifications
import AppKit

struct PresetChip: View {
    @EnvironmentObject var vm: FocusTimerViewModel
    let preset: FocusTimerViewModel.Preset
    var isSelected: Bool { vm.selectedPreset == preset }

    var body: some View {
        let pal = themeColors(vm.color, vm.appearance)
        Button(action: { vm.reset(to: preset); vm.start() }) {
            Text(preset.label).monospacedDigit()
                .padding(.vertical, 9)
                .padding(.horizontal, 14)
                .background(
                    Capsule()
                        .fill(isSelected ? pal.accent.opacity(0.25) : Color.gray.opacity(0.12))
                        .overlay(Capsule().stroke(Color.black.opacity(0.08), lineWidth: 1))
                )
        }
        .buttonStyle(.plain)
        .tint(pal.accent)
    }
}
