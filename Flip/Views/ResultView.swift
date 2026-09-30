//
//  ResultView.swift
//  Flip
//
//  Created by Наливайко Кирилл on 30.09.2026.
//

import SwiftUI


struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let angle: Double
}

    
struct ResultView: View {
    
    @State private var shownPercent = 0
    @State private var showingStats = false
    @State private var pieces: [ConfettiPiece] = (0..<14).map { _ in ConfettiPiece(color: [.flipCoral, .flipLavender, .flipMint, .flipButter].randomElement()!, x: CGFloat.random(in: -170...170), y: CGFloat.random(in: -380...0), size: CGFloat.random(in: 8...16), angle: CGFloat.random(in: 0...360))}
    @State private var dropped = false
    
    let deckTitle: String
    let known: Int
    let total: Int
    let missed: [Card]
    let minutes: Int
    let onRepeat: () -> Void
    let onClose: () -> Void
    
    var progress: Double {
        guard total > 0 else { return 0 }
        return Double(Double(known) / Double(total))
    }
    
    var percent: Int {
        Int(progress * 100)
    }
    
    var title: String {
        switch percent {
        case 80...100:
            "Отличный результат"
        case 50...80:
            "Хороший результат"
        default:
            "Нужно повторить"
        }
    }
    
    var body: some View {
        ZStack {
            Color.flipBackground.ignoresSafeArea()
            VStack(alignment: .leading,spacing: 22){
                //Шапка
                VStack(alignment: .leading, spacing: 6){
                    Text("\(deckTitle) · \(minutes) мин")
                        .font(.manrope(14, .medium))
                        .foregroundStyle(Color.flipMuted)
                    Text(title)
                        .font(.unbounded(28, .bold))
                        .foregroundStyle(Color.flipInk)
                        .tracking(-0.5)
                }
                
                // Кольцо
                ZStack{
                    ProgressRing(progress: self.progress, color: Color(hex: 0x57C9A0), lineWidth: 22)
                        .frame(width: 240, height: 240)
                        .overlay(alignment: .topTrailing){
                            Image(systemName: "star.fill")
                                .frame(width: 48, height: 48)
                                .background(Color.flipButter, in: Circle())
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(Color.flipButterInk)
                                .offset(x: 4, y: -4)
                                .phaseAnimator([1.0, 1.4, 0.9, 1.0]) { content, phase in
                                    content.scaleEffect(phase)
                                }
                        }
                        .frame(maxWidth: .infinity)
                        
                    
                    VStack(spacing: 2){
                        Text("\(shownPercent)%")
                            .font(.unbounded(52, .bold))
                            .foregroundStyle(Color.flipInk)
                            .tracking(-2)
                            .contentTransition(.numericText(value: Double(self.shownPercent)))
                            .onAppear {
                                withAnimation(.easeOut(duration: 1.2)) { shownPercent = percent }
                            }
                        Text("\(known) из \(total) слов")
                            .font(.manrope(14, .semibold))
                            .foregroundStyle(Color.flipMuted)
                    }
                }
                
                HStack(spacing: 10){
                    StatTile(value: "\(known)", label: "знаю", color: Color.flipMint, ink: Color.flipMintInk)
                    
                    StatTile(value: "\(missed.count)",label: "повторить", color: Color.flipPeach, ink: Color.flipPeachInk)
                    
                    StatTile(value: "+\(known * 10)", label: "очков", color: Color.flipLavender, ink: Color.flipLavenderInk)
                }
                    .opacity(showingStats ? 1: 0)
                    .offset(y: showingStats ? 0 : 30)
                    .onAppear{
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)){
                            showingStats = true
                        }
                    }
                
                if !missed.isEmpty{
                    VStack(alignment: .leading, spacing: 10){
                        Text("Слова на повтор")
                            .font(.manrope(14, .bold))
                            .foregroundStyle(Color.flipInk)
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(missed){ card in
                                    Text(card.word)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .font(.manrope(14, .semibold))
                                        .foregroundStyle(Color.flipInk)
                                        .background(Color(hex: 0xFFFDF8), in: Capsule())
                                        .overlay(Capsule().strokeBorder(Color.flipTrack, lineWidth: 1.5))
                                }
                            }
                        }.scrollIndicators(.hidden)
                    }
                }
                Spacer()
                VStack{
                    if !missed.isEmpty{
                        Button(action: {
                            onRepeat()
                        }){
                            Text("Повторить \(wordsForm(missed.count))")
                                .font(.manrope(16, .bold))
                                .foregroundStyle(Color.flipBackground)
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .background(Color.flipInk, in: RoundedRectangle(cornerRadius: 22))
                        }
                    }
                    
                    Button(action: {
                        onClose()
                    }){
                        Text("К колодам")
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.clear)
                            .font(.manrope(15, .semibold))
                            .foregroundStyle(Color.flipInk)
                            .contentShape(Rectangle())
                    }
                }.buttonStyle(PressableStyle())
                
            }
            .padding(.horizontal, 22)
            .padding(.top, 8)
            .padding(.bottom, 16)
            
            ForEach(self.pieces){ p in
                RoundedRectangle(cornerRadius: 3)
                    .fill(p.color)
                    .frame(width: p.size, height: p.size * 0.6)
                    .rotationEffect(.degrees(dropped ? p.angle : 0))
                    .offset(x: p.x, y: dropped ? p.y : -500)
            }.allowsHitTesting(false)

        }.onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.6)) {
                if percent >= 60{
                    dropped = true
                }
            }
        }
    }
}

#Preview {
    let cards = DeckStore().decks[0].cards
    ResultView(deckTitle: "Путешествия", known: 4, total: 6,
               missed: [cards[2], cards[3]], minutes: 4,
               onRepeat: {}, onClose: {})
}
