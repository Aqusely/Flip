//
//  FlipCard.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI

struct FlipCard:View{
    
    @Binding var isFlipped: Bool
    
    let card: Card
    let color: Color
    let inkColor: Color
    
    var body: some View{
        ZStack{
            CardBack(card: card)
                .opacity(isFlipped ? 1 : 0)
                .animation(.linear(duration: 0).delay(0.18), value: isFlipped)
                .rotation3DEffect(Angle(degrees: isFlipped ? 0 : 180), axis: (x:0, y:1, z:0))
            
            CardFront(card: card, color: color, inkColor: self.inkColor)
                .opacity(isFlipped ? 0 : 1)
                .animation(.linear(duration: 0).delay(0.18), value: isFlipped)
                .rotation3DEffect(Angle(degrees: isFlipped ? -180 : 0), axis: (x:0, y:1, z:0))
            
        }.onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)){
                self.isFlipped.toggle()
            }
        }
    }
}

#Preview {
    @Previewable @State var isFlipped = false
    let a = DeckStore().decks[0]
    FlipCard(isFlipped: $isFlipped, card: a.cards[0], color: a.color, inkColor: a.inkColor)
}
