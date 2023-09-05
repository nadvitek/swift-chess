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
    @Published var gameOver = false {
        didSet {
            if gameOver {
                showGameOver = true
                invalidateClocks()
            }
        }
    }
    @Published var whiteTime: Double = 1200
    @Published var blackTime: Double = 1200
    @Published var drawOffered = false
    var whiteClock: Timer?
    var blackClock: Timer?
    @Published var letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
    @Published var numbers = [0, 1, 2, 3, 4, 5, 6, 7]
    @Published var isReversed = false
    @Published var showGameOver = false
    @Published var allianceDrawOffered: Alliance = .White
    
    init() {
        startWhiteClock()
    }
    
    func nextTurn(shouldReverse: Bool) {
        playersTurn = playersTurn.switchAlliance
        if (playersTurn == .White) {
            startWhiteClock()
        } else {
            startBlackClock()
        }
        if (shouldReverse) {
            reverse()
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
            if (self.whiteTime > 0) {
                self.whiteTime -= 0.1
            } else {
                self.invalidateClocks()
                self.gameOver = true
            }
        }
    }
    
    func startBlackClock() {
        whiteClock?.invalidate()
        whiteClock = nil
        blackClock = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if (self.blackTime > 0) {
                self.blackTime -= 0.1
            } else {
                self.invalidateClocks()
                self.gameOver = true
            }
        }
    }
    
    func invalidateClocks() {
        whiteClock?.invalidate()
        whiteClock = nil
        blackClock?.invalidate()
        blackClock = nil
    }
    
    func reverse() {
        letters = letters.reversed()
        numbers = numbers.reversed()
        isReversed.toggle()
    }
}
