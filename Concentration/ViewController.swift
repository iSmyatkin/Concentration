//
//  ViewController.swift
//  Concentration
//
//  Created by Иван Смяткин on 11.09.2020.
//  Copyright © 2020 Иван Смяткин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    lazy var randomTheme = gameThemes.keys.randomElement()!
    lazy var emojiFromTheme: String! = gameThemes[randomTheme]
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    func updateFlipCountLabel() {
        let params: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        ]
        let paramString = NSAttributedString(string: "Flips: \(flipCount)", attributes: params)
        flipCountLabel.attributedText = paramString
    }
    
    var scoreCount = 0
    {
        didSet {
            scoreLabel.text = "Score: \(scoreCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }
    
    @IBAction func touchNewGameButton() {
        flipCount = 0
        scoreCount = 0
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        randomTheme = gameThemes.keys.randomElement()!
        emojiFromTheme = gameThemes[randomTheme]
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        scoreCount = game.score
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    var gameThemes = [
        "countries": "🏁🇦🇲🇦🇷🇧🇪🇬🇦🏴󠁧󠁢󠁥󠁮󠁧󠁿🇩🇪🇨🇳🇳🇫🇺🇸",
        "hearts": "❤️🧡💛💚💙💜🖤💖🤎💔",
        "fruits":"🍏🍎🍇🍓🍈🍒🍑🍍🥑🥝",
        "city transport": "🚗🚕🚙🚒🚑🚓🚲🚚🚎🚌",
        "animals": "🐶🐱🐭🐹🐰🦊🐻🐼🐷🐵",
        "clothes": "👚👔🧥👠👞🥾🎩🩱🧤🧢"]
    
    var emoji = [Card:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiFromTheme.count > 0 {
            emoji[card] = String(emojiFromTheme.popLast()!)
        }
        return emoji[card] ?? "?"
        
    }
}

