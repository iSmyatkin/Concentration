//
//  Theme.swift
//  Concentration
//
//  Created by Иван Смяткин on 12.11.2020.
//  Copyright © 2020 Иван Смяткин. All rights reserved.
//

import UIKit

enum Theme: CaseIterable {
    case countries
    case hearts
    case fruits
    case transport
    case animals
    case clothes
    
    var description: String {
      switch self {
      case .countries: return "Countries"
      case .hearts: return "Hearts"
      case .fruits: return "Fruits"
      case .transport: return "Transport"
      case .animals: return "Animals"
      case .clothes: return "Clothes"
      }
    }
    
    var emoji: String {
        switch self {
        case .countries: return "🏁🇦🇲🇦🇷🇧🇪🇬🇦🏴󠁧󠁢󠁥󠁮󠁧󠁿🇩🇪🇨🇳🇳🇫🇺🇸"
        case .hearts: return "❤️🧡💛💚💙💜🖤💖🤎💔"
        case .fruits: return "🍏🍎🍇🍓🍈🍒🍑🍍🥑🥝"
        case .transport: return "🚗🚕🚙🚒🚑🚓🚲🚚🚎🚌"
        case .animals: return "🐶🐱🐭🐹🐰🦊🐻🐼🐷🐵"
        case .clothes: return "👚👔🧥👠👞🥾🎩🩱🧤🧢"
        }
    }
    
    var themeColor: UIColor {
        switch self {
        case .countries: return .black
        case .hearts: return .orange
        case .fruits: return .yellow
        case .transport: return .red
        case .animals: return .brown
        case .clothes: return .gray
        }
    }
    
    static func getRandomTheme() -> Theme { return Theme.allCases.randomElement()! }
}
