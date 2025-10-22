//
//  FloatingTimerView.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//
import SwiftUI
import AppKit

struct FloatingTimerView: View {
    @EnvironmentObject var vm: FocusTimerViewModel
    var body: some View {
        let pal = themeColors(vm.color, vm.appearance)
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: pal.bg), startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.12)))
                .shadow(radius: 12)

            VStack(spacing: 12) {
                Text(vm.menuBarTitle)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .monospacedDigit()
                HStack(spacing: 12) {
                    Button(vm.isRunning ? "Pause" : "Start") { vm.toggle() }
                        .buttonStyle(.borderedProminent)
                    Button("Stop") { vm.stop() }
                        .buttonStyle(.bordered)
                }
                .tint(pal.accent)
            }
            .padding(18)
        }
        .frame(width: 240, height: 140)
    }
}
