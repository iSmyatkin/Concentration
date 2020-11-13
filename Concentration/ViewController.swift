//
//  ViewController.swift
//  Concentration§
//
//  Created by Иван Смяткин on 11.09.2020.
//  Copyright © 2020 Иван Смяткин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createTimer()
    }
    
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var randomTheme = Theme.getRandomTheme()
    lazy var themeTitle = randomTheme.description
    lazy var emojiChoices = randomTheme.emoji
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    var count = 0.0 {
        didSet {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = [.pad]
            timerLabel.text = formatter.string(from: count) ?? "??:??"
        }
    }
    var timer: Timer?
    
    var flipCount = 0 { didSet { updateFlipCountLabel() } }
    
    var scoreCount = 0
    {
        didSet {
            scoreLabel.text = "Score: \(scoreCount)"
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var flipCountLabel: UILabel! { didSet { updateFlipCountLabel() } }
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
        randomTheme = Theme.getRandomTheme()
        emojiChoices = randomTheme.emoji
        updateViewFromModel()
        cancelTimer()
        createTimer()
    }
    
    func cancelTimer() {
      timer?.invalidate()
      timer = nil
    }
    
    func createTimer() {
        if timer == nil {
            let timer = Timer(timeInterval: 1,
                            target: self,
                            selector: #selector(updateTimer),
                            userInfo: nil,
                            repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
            count = 0.0
        }
    }
    
    @objc func updateTimer() {
        count += 1
    }
    
    func updateFlipCountLabel() {
        let params: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        ]
        let paramString = NSAttributedString(string: "Flips: \(flipCount)", attributes: params)
        flipCountLabel.attributedText = paramString
    }
    
    func updateViewFromModel() {
        scoreCount = game.score
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = randomTheme.themeColor
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : randomTheme.themeColor
            }
        }
    }
    
    var emoji = [Card:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = String(emojiChoices.popLast()!)
        }
        return emoji[card] ?? "?"
        
    }
}

//    // MARK:  refactor time rounding
//    func customRound(number: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.maximumFractionDigits = 1
//        formatter.minimumFractionDigits = 1
//        formatter.roundingMode = .halfUp
//        formatter.numberStyle = .none
//        return formatter.string(for: number)!
//    }
