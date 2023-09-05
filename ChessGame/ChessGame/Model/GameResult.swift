//
//  GameResult.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 05.09.2023.
//

import Foundation

enum GameResult: Int {
    case None
    case WhiteWin
    case BlackWin
    case Draw
    
    
    func isResultClear() -> Bool {
        return self == .WhiteWin || self == .BlackWin
    }
    
    func getWhiteScore() -> String {
        return self == .WhiteWin ? "1" : (self == .BlackWin ? "0" : "1/2")
    }
    
    func getBlackScore() -> String {
        return self == .WhiteWin ? "0" : (self == .BlackWin ? "1" : "1/2")
    }
}
