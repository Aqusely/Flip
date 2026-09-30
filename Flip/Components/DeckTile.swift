//
//  DeckTile.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI

struct DeckTile: View {
    
    @State private var shown = false
    let deck: Deck
    let index: Int // порядок карточки
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: deck.icon)
                    .frame(width: 42, height: 42)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .background(.white.opacity(0.55))
                    .font(.system(size: 19,weight: .medium))
                Spacer()
                ProgressRing(progress: deck.progress, color: deck.inkColor)
                    .frame(width: 40, height: 40)
            }
            Spacer()
            VStack(alignment: .leading,spacing: 2){
                Text(deck.title)
                    .font(.unbounded(16, .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("\(wordsForm(deck.cards.count)) · \(Int(deck.progress*100))%")
                    .font(.manrope(13, .medium))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 170)
        .background(deck.color, in: RoundedRectangle(cornerRadius: 28))
        .foregroundStyle(deck.inkColor)
        .opacity(shown ? 1 : 0)
        .offset(y: shown ? 0 : 20)
        .onAppear{
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.08)){
                self.shown = true
            }
        }
        
    }
}

#Preview {
    DeckTile(deck: DeckStore().decks[0], index: 1)
}
