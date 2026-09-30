//
//  PressableStyle.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview{
    DeckTile(deck: DeckStore().decks[0], index: 1)
}
