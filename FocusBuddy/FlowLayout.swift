//
//  FlowLayout.swift
//  FocusBuddy
//
//  Created by Rana Taki on 8/19/25.
//

import Foundation
import SwiftUI
import AppKit

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    var items: Data
    var spacing: CGFloat
    var content: (Data.Element) -> Content

    init(items: Data, spacing: CGFloat, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.items = items; self.spacing = spacing; self.content = content
    }

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(items) { item in
                    content(item)
                        .padding(.all, 4)
                        .alignmentGuide(.leading) { d in
                            if abs(width - d.width) > geo.size.width {
                                width = 0; height -= d.height + spacing
                            }
                            let result = width
                            if item.id == items.last?.id { width = 0 }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if item.id == items.last?.id { height = 0 }
                            return result
                        }
                }
            }
        }.frame(height: 120)
    }
}
