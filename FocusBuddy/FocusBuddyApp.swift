//
//  FocusBuddyApp.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//

import SwiftUI
import Combine
import UserNotifications
import AppKit

@main
struct FocusBuddyApp: App {
    @StateObject private var timerVM = FocusTimerViewModel()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    var body: some Scene {
        MenuBarExtra(content: {
            ContentView()
                .environmentObject(timerVM)
                .preferredColorScheme(timerVM.appearance == .system ? nil : (timerVM.appearance == .light ? .light : .dark))
                .frame(width: 320)
                .padding(16)
        }, label: {
            Text(timerVM.menuBarTitle)
                .monospacedDigit()
        })
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environmentObject(timerVM)
                .frame(width: 360)
                .padding()
        }
    }
}
