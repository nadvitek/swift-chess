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
    let blackPlayer: String
    let whitePlayer: String
    let result: GameResult
    var dataFormat: [String: Any] {
        get {
            return ["blackPlayer" : blackPlayer,
                    "id": id,
                    "whitePlayer": whitePlayer,
                    "result": result.rawValue,
                    "date": date]
        }
    }
    
    init(id: String = UUID().uuidString, date: Date, whitePlayer: String, blackPlayer: String, result: GameResult) {
        self.id = id
        self.date = date
        self.whitePlayer = whitePlayer
        self.blackPlayer = blackPlayer
        self.result = result
    }
}
