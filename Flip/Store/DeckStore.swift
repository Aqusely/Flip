//
//  DeckStore.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI
internal import Combine

class DeckStore: ObservableObject {
    
    @Published var decks: [Deck] = [
        
        Deck(title: "Путешествия", color: .flipPeach, inkColor: .flipPeachInk,
             icon: "airplane", cards: [
                Card(word: "luggage", transcription: "/ˈlʌɡ.ɪdʒ/", translation: "багаж",
                     example: "I can’t find my luggage anywhere.", known: true),
                Card(word: "boarding pass", transcription: "/ˈbɔː.dɪŋ pɑːs/", translation: "посадочный талон",
                     example: "Please show your boarding pass.", known: true),
                Card(word: "layover", transcription: "/ˈleɪˌəʊ.vər/", translation: "пересадка",
                     example: "We have a three-hour layover in Istanbul.", known: false),
                Card(word: "customs", transcription: "/ˈkʌs.təmz/", translation: "таможня",
                     example: "It took an hour to get through customs."),
                Card(word: "aisle", transcription: "/aɪl/", translation: "проход (в самолёте)",
                     example: "Can I have an aisle seat?"),
                Card(word: "departure", transcription: "/dɪˈpɑː.tʃər/", translation: "отправление, вылет",
                     example: "Our departure is at 7 a.m.", known: true)
             ]),

        Deck(title: "Еда", color: .flipLavender, inkColor: .flipLavenderInk,
             icon: "fork.knife", cards: [
                Card(word: "appetizer", transcription: "/ˈæp.ə.taɪ.zər/", translation: "закуска",
                     example: "Let’s order an appetizer to share.", known: true),
                Card(word: "bill", transcription: "/bɪl/", translation: "счёт",
                     example: "Could we have the bill, please?"),
                Card(word: "spicy", transcription: "/ˈspaɪ.si/", translation: "острый",
                     example: "This soup is too spicy for me.", partOfSpeech: "прилагательное", known: false),
                Card(word: "leftovers", transcription: "/ˈleftˌəʊ.vərz/", translation: "остатки еды",
                     example: "We had leftovers for lunch."),
                Card(word: "grocery", transcription: "/ˈɡrəʊ.sər.i/", translation: "продуктовый магазин",
                     example: "I need to stop by the grocery store."),
                Card(word: "recipe", transcription: "/ˈres.ɪ.pi/", translation: "рецепт",
                     example: "This is my grandmother’s recipe.")
             ]),

        Deck(title: "Работа", color: .flipMint, inkColor: .flipMintInk,
             icon: "briefcase", cards: [
                Card(word: "deadline", transcription: "/ˈded.laɪn/", translation: "срок сдачи",
                     example: "The deadline is next Friday.", known: true),
                Card(word: "salary", transcription: "/ˈsæl.ər.i/", translation: "зарплата",
                     example: "She asked for a higher salary.", known: true),
                Card(word: "colleague", transcription: "/ˈkɒl.iːɡ/", translation: "коллега",
                     example: "My colleague helped me with the report.", known: true),
                Card(word: "meeting", transcription: "/ˈmiː.tɪŋ/", translation: "встреча, совещание",
                     example: "The meeting was moved to 3 p.m.", known: true),
                Card(word: "promotion", transcription: "/prəˈməʊ.ʃən/", translation: "повышение",
                     example: "He got a promotion last month.", known: true),
                Card(word: "resign", transcription: "/rɪˈzaɪn/", translation: "уволиться по собственному",
                     example: "She decided to resign and travel.", partOfSpeech: "глагол")
             ])
    ]
    
    func answer(card: Card, in deck: Deck, known: Bool) {
        guard let d = decks.firstIndex(where: {$0.id == deck.id}),
              let c = decks[d].cards.firstIndex(where: {$0.id == card.id}) else { return }
        decks[d].cards[c].known = known
    }
    
    func resetAnswer(card: Card, in deck: Deck) -> Void {
        guard let d = decks.firstIndex(where: {$0.id == deck.id}),
              let c = decks[d].cards.firstIndex(where: {$0.id == card.id}) else { return }
        decks[d].cards[c].known = nil
            
    }
}
