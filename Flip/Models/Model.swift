//
//  Model.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI

//Карточка
struct Card: Identifiable, Codable{
    var id = UUID()
    let word: String
    let transcription: String
    let translation: String
    let example: String
    var partOfSpeech = "существительное"
    var known: Bool?
}

// Дэк со списком карточек
struct Deck: Identifiable{
    var id = UUID()
    let title: String
    
    let color: Color
    let inkColor: Color
    
    let icon: String
    var cards: [Card]
    var progress: Double {
        guard !cards.isEmpty else { return 0 }
        return Double(cards.filter({$0.known ?? false}).count) / Double(cards.count)
    }
}

func wordsForm(_ n: Int) -> String {
    let lastTwo = n % 100
    let last = n % 10
    if (11...14).contains(lastTwo) { return "\(n) слов" }
    if last == 1 { return "\(n) слово" }
    if (2...4).contains(last) { return "\(n) слова" }
    return "\(n) слов"
}
