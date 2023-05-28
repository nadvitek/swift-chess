//
//  GameViewModel.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 27.05.2023.
//

import Foundation


@MainActor class GameViewModel: ObservableObject {
    @Published var playersTurn: Alliance = .White
    
    func nextTurn() {
        playersTurn = playersTurn.switchAlliance
    }
}
