//
//  ThemePal.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//

import Foundation
import SwiftUI
import AppKit

struct ThemePal { let bg: [Color]; let accent: Color }

func themeColors(_ color: FocusTimerViewModel.ColorTheme,
                 _ appearance: FocusTimerViewModel.Theme) -> ThemePal {
    let isLight = (appearance != .dark)
    switch color {
    case .sunset:
        let bg = isLight ? [Color.white, Color.orange.opacity(0.18)]
                         : [Color(red: 0.20, green: 0.12, blue: 0.22), Color(red: 0.36, green: 0.17, blue: 0.19)]
        return .init(bg: bg, accent: .orange)
    case .mint:
        let bg = isLight ? [Color.white, Color.mint.opacity(0.18)]
                         : [Color(red: 0.09, green: 0.16, blue: 0.22), Color(red: 0.09, green: 0.35, blue: 0.33)]
        return .init(bg: bg, accent: .mint)
    case .electric:
        let bg = isLight ? [Color.white, Color.cyan.opacity(0.20)]
                         : [Color(red: 0.07, green: 0.08, blue: 0.18), Color(red: 0.09, green: 0.14, blue: 0.30)]
        return .init(bg: bg, accent: .cyan)
    case .graphite:
        let bg = isLight ? [Color.white, Color.gray.opacity(0.10)]
                         : [Color(red: 0.11, green: 0.11, blue: 0.12), Color(red: 0.17, green: 0.18, blue: 0.19)]
        return .init(bg: bg, accent: .gray)
    }
}

