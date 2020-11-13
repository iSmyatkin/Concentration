//
//  Concentration.swift
//  Concentration
//
//  Created by Иван Смяткин on 11.09.2020.
//  Copyright © 2020 Иван Смяткин. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var score = 0 {
        didSet {
            if score < 0 { score = 0 }
        }
    }
    
    var presentedCards = Set<Card>()
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // MARK:  check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    // MARK:  if isPresented -1 point
                    //print("before \(presentedCards.sorted())")
                    if presentedCards.contains(cards[matchIndex]) { score -= 1 }
                    if presentedCards.contains(cards[index]) { score -= 1 }
                    presentedCards.insert(cards[matchIndex])
                    presentedCards.insert(cards[index])
                    //print("after \(presentedCards.sorted())")
                }
                cards[index].isFaceUp = true
            } else {
                // MARK:  either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // MARK:  Shuffle the cards
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        count == 1 ? first : nil
    }
}
