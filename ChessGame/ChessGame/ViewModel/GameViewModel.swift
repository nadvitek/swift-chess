//
//  GameViewModel.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 27.05.2023.
//

import Foundation
import Dispatch

class GameViewModel: ObservableObject {
    @Published var playersTurn: Alliance = .White
    @Published var gameOver = false
    @Published var whiteTime: Double = 1200
    @Published var blackTime: Double = 1200
    @Published var blackPlayerName: String = "Player Black"
    @Published var whitePlayerName: String = "Player White"
    var whiteClock: Timer?
    var blackClock: Timer?
    
    init() {
        startWhiteClock()
    }
    
    func nextTurn() {
        playersTurn = playersTurn.switchAlliance
        if (playersTurn == .White) {
            startWhiteClock()
        } else {
            startBlackClock()
        }
    }
    
    func showBlackTime() -> String {
        return showTime(time: blackTime)
    }
    
    func showWhiteTime() -> String {
        return showTime(time: whiteTime)
    }
    
    func showTime(time: Double) -> String {
        let minutes = Int(time / 60)
        let seconds = String(format: "%02d", Int(time) % 60)
        return "\(minutes):\(seconds)"
    }
    
    func startWhiteClock() {
        blackClock?.invalidate()
        blackClock = nil
        whiteClock = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.whiteTime -= 0.1
        }
    }
    
    func startBlackClock() {
        whiteClock?.invalidate()
        whiteClock = nil
        blackClock = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.blackTime -= 0.1
        }
    }
}
