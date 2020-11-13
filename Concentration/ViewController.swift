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
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    private var randomTheme = Theme.getRandomTheme()
    private var themeTitle: String { randomTheme.description }
    private lazy var emojiChoices = randomTheme.emoji
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private var count = 0.0 {
        didSet {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = [.pad]
            timerLabel.text = formatter.string(from: count) ?? "??:??"
        }
    }
    private var timer: Timer?
    private var flipCount = 0 { didSet { updateFlipCountLabel() } }
    private var scoreCount = 0 { didSet { scoreLabel.text = "Score: \(scoreCount)" } }
    
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel! { didSet { updateFlipCountLabel() } }
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }
    
    @IBAction private func touchNewGameButton() {
        flipCount = 0
        scoreCount = 0
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        randomTheme = Theme.getRandomTheme()
        //emojiChoices = randomTheme.emoji
        updateViewFromModel()
        cancelTimer()
        createTimer()
    }
    
    private func cancelTimer() {
      timer?.invalidate()
      timer = nil
    }
    
    private func createTimer() {
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
    
    @objc private func updateTimer() {
        count += 1
    }
    
    private func updateFlipCountLabel() {
        let params: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        ]
        let paramString = NSAttributedString(string: "Flips: \(flipCount)", attributes: params)
        flipCountLabel.attributedText = paramString
    }
    
    private func updateViewFromModel() {
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
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
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
