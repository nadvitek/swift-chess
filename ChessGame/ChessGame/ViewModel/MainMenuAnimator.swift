//
//  MainMenuAnimator.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 03.09.2023.
//

import Foundation

class MainMenuAnimator: ObservableObject {
    @Published var setNicknameView = false
    @Published var multiPlayerSelected = false
    @Published var customBoardSelected = false
    @Published var singlePlayerSelected = false
    @Published var blackPlayerChosen = true
    @Published var aiChosen = true
    @Published var infoViewShown = false
    
    func bgDisabled() -> Bool {
        return setNicknameView || multiPlayerSelected || singlePlayerSelected || customBoardSelected || infoViewShown
    }
}
