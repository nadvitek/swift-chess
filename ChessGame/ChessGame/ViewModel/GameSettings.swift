//
//  GameSettings.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 26.08.2023.
//

import Foundation

class GameSettings: ObservableObject {
    @Published var gameStarted = false
    @Published var whitePlayerName = "Player White"
    @Published var blackPlayerName = "Player Black"
    
    var gameResult: GameResult = .None
    
    var gameType: GameType = .Offline
    var playersAlliance: Alliance = .Black
    
    
    func isBotOnTurn(alliance: Alliance) -> Bool {
        return gameType == .Bot && playersAlliance != alliance
    }
    
    func showActionButton(alliance: Alliance) -> Bool {
        if gameType == .Bot {
            if (playersAlliance != alliance) {
                return false
            }
            return true
        }
        return true
    }
}

enum GameType {
    case None, Bot, Offline
}
