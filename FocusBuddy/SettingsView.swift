//
//  SettingsView.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//

import Foundation
import SwiftUI
import AppKit

struct SettingsView: View {
    @EnvironmentObject var vm: FocusTimerViewModel
    var body: some View {
        Form {
            Section("Theme") {
                HStack {
                    Text("Color")
                    Spacer()
                    Menu(vm.color.rawValue.capitalized) {
                        ForEach(FocusTimerViewModel.ColorTheme.allCases) { c in
                            Button(action: { vm.setColor(c) }) {
                                HStack { Text(c.rawValue.capitalized); if vm.color == c { Spacer(); Image(systemName: "checkmark") } }
                            }
                        }
                    }
                }
                Picker("Appearance", selection: Binding(get: { vm.appearance }, set: { vm.setTheme($0) })) {
                    ForEach(FocusTimerViewModel.Theme.allCases) { a in
                        Text(a.rawValue.capitalized).tag(a)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section("About") {
                Text("FocusBuddy — sleek, minimal focus timer for your menu bar.")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
