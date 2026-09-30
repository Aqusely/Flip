//
//  StudyView.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI

struct StudyView: View{
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isFlippeed: Bool = false
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var isAnimating = false
    
    @ObservedObject var deckStore: DeckStore
    let deckID: UUID
    
    var deck: Deck {
        deckStore.decks.first(where: { $0.id == deckID })!
    }
    // Штамп ЗНАЮ
    var knowOpacity: Double {
        min(dragOffset.width, 120) / 120
    }
    
    // Штамп НЕ ЗНАЮ
    var dontKnowOpacity: Double {
        max(dragOffset.width, -120) / -120
    }
    
    @State private var answers: [Bool] = []
    @State private var sessionCards: [Card] = []  // Отвеченные карточки
    @State private var startDate = Date()  // Время начала прохождения
    
    // Сколько знаю
    var knowCount: Int {
        self.answers.filter( {$0 == true} ).count
    }
    // Карточки которые не знаю
    var missedCard: [Card] {
        
        var result: [Card] = []
        for i in self.answers.indices {
            if answers[i] == false {
                result.append(sessionCards[i])
            }
        }
        return result
    }
    
    // Сколько заняло времени
    var minutes: Int {
        Int(max(1, Date().timeIntervalSince(startDate) / 60))
    }
    
    var body: some View{
        ZStack{
            Color.flipBackground.ignoresSafeArea()
            if self.sessionCards.isEmpty {
                Color.clear
            } else if self.currentIndex < self.sessionCards.count {
                VStack(spacing: 18){
                    HStack{
                        Button(action:{
                            dismiss()
                        }){
                            Image(systemName: "chevron.left")
                                .frame(width: 44, height: 44)
                                .background(Color.flipChip, in: Circle())
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color.flipInk)
                        }
                        Spacer()
                        VStack{
                            Text(deck.title)
                                .font(.unbounded(16, .bold))
                                .foregroundStyle(Color.flipInk)
                            Text("\(currentIndex+1) из \(sessionCards.count)")
                                .font(.manrope(13, .medium))
                                .foregroundStyle(Color.flipMuted)
                                .contentTransition(.numericText())
                        }
                        Spacer()
                        Button(action:{
                            //
                        }){
                            Image(systemName: "speaker.wave.2")
                                .frame(width: 44, height: 44)
                                .background(Color.flipChip, in: Circle())
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color.flipInk)
                        }
                        
                    }
                    
                    HStack(spacing: 4){
                        ForEach(sessionCards.indices, id: \.self){ index in
                            Capsule()
                                .frame(height: 6)
                                .foregroundStyle(segmentColor(index))
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 34)
                            .frame(height: 440)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.flipMint)
                            .rotationEffect(Angle(degrees: 5))
                            .padding(.horizontal, 34)
                            .offset(y:14)
                        RoundedRectangle(cornerRadius: 34)
                            .frame(height: 440)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.flipLavender)
                            .rotationEffect(Angle(degrees: -3))
                            .padding(.horizontal, 18)
                            .offset(y:8)
                        
                        
                        
                        FlipCard(isFlipped: $isFlippeed, card: sessionCards[currentIndex], color: deck.color, inkColor: deck.inkColor)
                            .overlay(alignment: .topLeading){
                                Text("ЗНАЮ")
                                    .font(.unbounded(14, .bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(style: StrokeStyle(lineWidth: 3)))
                                    .rotationEffect(Angle(degrees: 12))
                                    .padding(24)
                                    .foregroundStyle(Color.flipMintInk)
                                    .opacity(knowOpacity)
                            }
                            .overlay(alignment: .topTrailing){
                                Text("НЕ ЗНАЮ")
                                    .font(.unbounded(14, .bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(style: StrokeStyle(lineWidth: 3)))
                                    .rotationEffect(Angle(degrees: -12))
                                    .padding(24)
                                    .foregroundStyle(Color.flipCoral)
                                    .opacity(dontKnowOpacity)
                            }
                            .rotationEffect(Angle(degrees: dragOffset.width / 10))
                            .offset(dragOffset)
                            .gesture(
                                DragGesture(minimumDistance: 10)
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded{ value in
                                        if abs(value.translation.width) > 120 {
                                            swipe(known: value.translation.width > 0)
                                        }else{
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)){
                                                dragOffset = .zero
                                            }
                                        }
                                    }
                            )
                            .id(sessionCards[currentIndex].id)
                            .transition(.scale(scale: 0.9).combined(with: .opacity))
                            .zIndex(1)
                    }
                    
                    Spacer()
                    HStack(spacing: 12){
                        Button(action: {
                            swipe(known: false)
                        }){
                            HStack{
                                Image(systemName: "xmark")
                                Text("Не знаю")
                            }.frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(RoundedRectangle(cornerRadius: 22).strokeBorder(Color.flipInk, lineWidth: 2))
                                .foregroundStyle(Color.flipInk)
                                .font(.manrope(16, .bold))
                        }.buttonStyle(PressableStyle())
                        Button(action: {
                            guard currentIndex > 0 else { return }
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)){
                                self.currentIndex -= 1
                            }
                            deckStore.resetAnswer(card: self.sessionCards[currentIndex], in: deck)
                            guard !self.answers.isEmpty else { return }
                            self.answers.removeLast()
                        }){
                            Image(systemName: "arrow.uturn.backward")
                                .frame(width: 52, height: 52)
                                .background(Color.flipChip, in: Circle())
                                .foregroundStyle(Color.flipInk)
                                .font(.manrope(16, .bold))
                            
                        }.buttonStyle(PressableStyle())
                        Button(action: {
                            swipe(known: true)
                        }){
                            HStack{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.flipMint)
                                Text("Знаю")
                                    .foregroundStyle(Color.flipBackground)
                            }.frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color.flipInk, in: RoundedRectangle(cornerRadius: 22))
                                .font(.manrope(16, .bold))
                        }.buttonStyle(PressableStyle())
                    }
                }.padding(.horizontal, 22)
            } else {
                ResultView(deckTitle: deck.title, known: knowCount, total: sessionCards.count, missed: missedCard, minutes: self.minutes, onRepeat: {repeatMistake()}, onClose: {dismiss()})
                    .transition(.opacity)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear{
            if self.sessionCards.isEmpty {
                self.sessionCards = self.deck.cards
            }
        }
    }
    
    func segmentColor(_ index: Int) -> Color {
        if index < currentIndex {
            return Color.flipInk
        }else if index == currentIndex {
            return Color.flipCoral
        }else{
            return Color.flipTrack
        }
    }
    
    func answer(known: Bool) -> Void {
        guard currentIndex < sessionCards.count else { return }
        deckStore.answer(card: self.sessionCards[currentIndex], in: deck, known: known)
        
        withAnimation(.easeOut(duration: 0.3)){
            currentIndex += 1
        }
        
        self.isFlippeed = false
        dragOffset = .zero
        self.answers.append(known)
        
    }
    
    func swipe(known: Bool) {
        guard !isAnimating else { return }
        isAnimating = true
        withAnimation(.easeIn(duration: 0.25)) {
            dragOffset.width = known ? 500 : -500
        } completion: {
            answer(known: known)
            isAnimating = false
        }
    }
    
    func repeatMistake() -> Void {
        let misstake = missedCard
        withAnimation{
            sessionCards = misstake
            self.answers = []
            currentIndex = 0
        }
        self.isFlippeed = false
        self.dragOffset = .zero
        self.startDate = Date()
    }
}

#Preview {
    let a = DeckStore()
    StudyView(deckStore: a, deckID: a.decks[0].id)
}
