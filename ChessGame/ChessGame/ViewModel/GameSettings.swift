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
    
    var gameType: GameType = .None
    var playersAlliance: Alliance = .White
    
}

enum GameType {
    case None, Bot, Offline
}
