//
//  CardFront.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI

struct CardFront: View {
    
    let card: Card
    let color: Color
    let inkColor: Color
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            VStack(spacing: 12){
                Text(card.partOfSpeech)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .font(.manrope(13, .semibold))
                    .background(Color.white.opacity(0.55), in: Capsule())
                Text(card.word)
                    .font(.unbounded(44, .bold))
                    .tracking(-1)
                Text(card.transcription)
                    .font(.manrope(17, .medium))
            }
            .frame(height: 440)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(color, in: RoundedRectangle(cornerRadius: 34))
            HStack(spacing: 8){
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 16, weight: .semibold))
                Text("Нажми, чтобы перевернуть")
                    .font(.manrope(14, .semibold))
            }.padding(.bottom, 26)
              
        }  .foregroundStyle(inkColor)
    }
}

#Preview{
    CardFront(card: DeckStore().decks[0].cards[0], color: DeckStore().decks[0].color, inkColor: DeckStore().decks[0].inkColor)
}
