//
//  Game.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 23.08.2023.
//

import Foundation

struct Game: Identifiable {
    var id: String
    let date: Date
    let opponent: String
    let alliance: Alliance
    let state: GameState
    
    init(id: String = UUID().uuidString, date: Date, opponent: String, alliance: Alliance, state: GameState) {
        self.id = id
        self.date = date
        self.opponent = opponent
        self.alliance = alliance
        self.state = state
    }
}

enum GameState: String {
    case Win = "1"
    case Lose = "0"
    case Draw = "1/2"
    
    
    func getOpposite() -> GameState {
        switch self {
        case .Draw:
            return .Draw
        case .Lose:
            return .Win
        case .Win:
            return .Lose
        }
    }
}
