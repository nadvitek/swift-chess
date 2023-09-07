//
//  BoardView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 30.08.2023.
//

import SwiftUI

struct BoardView: View {
    @StateObject var boardViewModel = BoardViewModel()
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var gameSettings: GameSettings
    let boardSize: Double
    
    
    init(size: Double) {
        self.boardSize = size
    }
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .frame(width: boardSize + 2, height: boardSize + 2)
                .foregroundColor(Color("boardFrameColor"))
            
            Rectangle()
                .frame(width: boardSize, height: boardSize)
                .foregroundColor(Color("boardColor"))
            
            
            
            
            VStack(spacing:2) {
                HStack(spacing:5) {
                    VStack(spacing: boardSize/19) {
                        ForEach((gameViewModel.numbers), id:\.self) { i in
                            Text(String(8 - i))
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }.frame(height: boardSize*0.8)
                    HStack(spacing:1) {
                        ForEach((gameViewModel.numbers), id:\.self) { x in
                            VStack(spacing:1) {
                                ForEach((gameViewModel.numbers).reversed(), id:\.self) { y in
                                    TileView(tile: boardViewModel.board[y][x], tileSize: boardSize * 0.106, action: {self.tileAction(x: x, y: y)})
                                }
                            }
                        }
                    }
                }.offset(x:-7)
                HStack(spacing: boardSize/13) {
                    ForEach(0..<8) { i in
                        Text(gameViewModel.letters[i])
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                }
            }.offset(y:10)
                .onAppear {
                    playBot()
                }
            
            if (boardViewModel.processingPromotion) {
                PromotionView(size: boardSize, piece: boardViewModel.promotedPiece!, action: {finishPromotion()})
                    .offset(y: boardSize * getPositionOfPromotionView())
            }
            
            
        }.frame(alignment: .center)
        
    }
    
    func getPositionOfPromotionView() -> Double {
        if gameViewModel.isReversed {
            return boardViewModel.promotedPiece?.alliance == .White ? -0.62 : 0.62
        } else {
            return boardViewModel.promotedPiece?.alliance == .White ? 0.62 : -0.62
        }
    }
    
    func finishPromotion() {
        boardViewModel.promotedPiece = nil
        playBot()
    }
    
    func tileAction(x: Int, y: Int) {
        let moveExecuted = boardViewModel.processTile(x: x, y: y, onTurn: gameViewModel.playersTurn)
        if moveExecuted {
            gameViewModel.nextTurn(shouldReverse:gameSettings.gameType == .Offline)
            playBot()
        }
        if boardViewModel.gameOver {
            boardViewModel.decideResult()
            gameSettings.gameResult = boardViewModel.gameResult
            gameViewModel.gameOver = true
        }
        
    }
    
    func playBot() {
        if (gameSettings.isBotOnTurn(alliance: gameViewModel.playersTurn) && !gameViewModel.gameOver  && !boardViewModel.processingPromotion) {
            guard !boardViewModel.getOnTurnPlayersMoves().isEmpty else {
                boardViewModel.decideResult()
                gameSettings.gameResult = boardViewModel.gameResult
                gameViewModel.gameOver = true
                return
            }
            let move = boardViewModel.getOnTurnPlayersMoves().randomElement()
            tileAction(x: move!.sourceTile.x, y: move!.sourceTile.y)
            tileAction(x: move!.destinationTile.x, y: move!.destinationTile.y)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(size: 350)
            .environmentObject(GameViewModel())
            .environmentObject(GameSettings())
    }
}
