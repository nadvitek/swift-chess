//
//  GameSettings.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 26.08.2023.
//

import Foundation

class GameSettings: ObservableObject {
    @Published var gameStarted = false
    @Published var gameType: GameType = .None {
        didSet {
            gameStarted = true
        }
    }
}

enum GameType {
    case None, Bot, Offline
}
