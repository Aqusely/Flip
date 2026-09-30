//
//  CardBack.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI


struct CardBack: View{
    
    let card: Card
    
    var body: some View {
        VStack(spacing: 14){
            Text(card.word)
                .font(.manrope(13, .semibold))
                .foregroundStyle(Color.flipMuted)
            Text(card.translation)
                .font(.unbounded(40, .bold))
                .foregroundStyle(Color(hex: 0xC24A26))
            RoundedRectangle(cornerRadius: 14)
                .frame(width:40, height: 3)
                .foregroundStyle(Color.flipTrack)
            Text(card.example)
                .font(.manrope(16))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.flipInk)
                
        }.frame(height: 440)
        .padding(.horizontal,28)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(hex: 0xFFFDF8), in: RoundedRectangle(cornerRadius: 34))
        .overlay(
            RoundedRectangle(cornerRadius: 34).strokeBorder(Color.flipInk, lineWidth: 2)
        )
    }
}

#Preview{
    let a = DeckStore().decks[0]
    CardBack(card:a.cards[0])
}
