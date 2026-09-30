import SwiftUI

// Экран 1 — колоды. Начни отсюда (шаг 3 плана).
struct DecksView: View {
    
    @ObservedObject var store: DeckStore
    @State private var selection = 0
    @State private var pulse: Bool = false
    @State private var showLast = false
    
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.flipBackground.ignoresSafeArea()
            ScrollView{
                VStack(alignment: .leading, spacing: 22){
                    //Шапка
                    HStack(alignment: .top){
                        VStack(alignment: .leading, spacing: 6) {
                            Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide).locale(Locale(identifier: "ru_RU"))))
                                .font(.manrope(14, .medium))
                                .foregroundStyle(Color.flipMuted)
                            Text("Что учим \nсегодня?")
                                .font(.unbounded(28, .bold))
                                .foregroundStyle(Color.flipInk)
                                .tracking(-0.5)
                        }
                        Spacer()
                        Circle()
                            .fill(Color.flipButter)
                            .frame(width: 48, height: 48)
                            .overlay{
                                Text("K")
                                    .font(.unbounded(16, .bold))
                                    .foregroundStyle(Color.flipButterInk)
                            }
                    }
                    
                    // Цель дня
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 2){
                                Text("Цель дня")
                                    .font(.manrope(13))
                                    .foregroundStyle(Color.flipOnInk)
                                HStack(alignment: .bottom, spacing: 4){
                                    Text("12")
                                        .font(.unbounded(24, .bold))
                                        .foregroundStyle(Color.flipBackground)
                                    Text("/ 20 слов")
                                        .font(.unbounded(16, .medium))
                                        .foregroundStyle(Color.flipOnInkDim)
                                }
                            }
                            Spacer()
                            HStack(spacing: 6){
                                Image(systemName: "flame")
                                    .font(.system(size: 14, weight: .semibold))
                                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) { content in
                                        content.scaleEffect(pulse ? 1.2 : 1)
                                    }
                                    .onAppear{
                                        self.pulse = true
                                    }
                                Text("7 дней подряд")
                                    .font(.manrope(13, .semibold))
                            }.foregroundStyle(Color.flipButter)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color.flipInkRaised))
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading){
                                Capsule().fill(Color.flipInkRaised).frame(width: geo.size.width, height: 10)
                                Capsule().fill(Color.flipButter).frame(width: geo.size.width*0.6, height: 10)
                            }
                        }.frame(height: 10)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 22)
                    .background(Color.flipInk, in: RoundedRectangle(cornerRadius: 28))
                    
                    // Колоды
                    HStack(spacing: 20){
                        Text("Колоды")
                            .font(.flipHeading)
                            .foregroundStyle(Color.flipInk)
                        Spacer()
                        Button(action:{
                            //
                        }){
                            Text("Все")
                                .font(.manrope(14, .semibold))
                                .foregroundStyle(Color.flipMuted)
                        }
                    }
                    
                    //Карточки через LazyVGrid (НОВОЕ)
                    LazyVGrid(columns: columns, spacing: 12){
                        ForEach(Array(store.decks.enumerated()), id:\.element.id){index, deck in
                            NavigationLink(destination: StudyView(deckStore: store, deckID: deck.id)){
                                DeckTile(deck: deck, index: index)
                            }.buttonStyle(PressableStyle())
                        }
                        
                        
                        Button(action:{
                            //
                        }){
                            VStack{
                                ZStack{
                                    Circle().fill(Color.flipChip)
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "plus")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(Color.flipInk)
                                }
                                Text("Новая колода")
                                    .font(.manrope(14, .semibold))
                                    .foregroundStyle(Color.flipMuted)
                            }.frame(height: 170)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 28)
                                    .strokeBorder(Color.flipDashed, style: StrokeStyle(lineWidth: 2, dash: [6, 6])))
                        }.buttonStyle(PressableStyle())
                            .opacity(showLast ? 1 : 0)
                            .offset(y: showLast ? 0 : 20)
                            .onAppear{
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(store.decks.count) * 0.08)){
                                    self.showLast = true
                                }
                            }
                        
                    }.padding(.bottom, 110)
                }
                .padding(.horizontal, 22)
                .padding(.top, 8)
                
            }
            
            TabBar(selection: $selection)
            
        }
    }
}

#Preview {
    DecksView(store: DeckStore())
}
