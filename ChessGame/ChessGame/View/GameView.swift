//
//  GameView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 22.05.2023.
//

import SwiftUI

struct GameView: View {
    @StateObject var gameViewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geo in
                Rectangle()
                    .fill()
                    .ignoresSafeArea()
                    .foregroundColor(Color("backgroundColor"))
            VStack {
                HStack {
                    Text("Player Black")
                        .font(.custom("VarelaRound-Regular", size: 30))
                    Spacer()
                    Text("20:00")
                        .font(.custom("VarelaRound-Regular", size: 30))
                }.padding()
                
                OptionsButtonView(size: geo.size.width * 0.15)
                
                BoardView(size: geo.size.width * 0.9)
                    .environmentObject(gameViewModel)
                
                HStack {
                    Text("20:00")
                        .font(.custom("VarelaRound-Regular", size: 30))
                    Spacer()
                    Text("Player White")
                        .font(.custom("VarelaRound-Regular", size: 30))
                }.padding()
                
            }
            
            if(gameViewModel.gameOver) {
                Text("\(gameViewModel.playersTurn.switchAlliance.description) Player Wins! \(geo.size.width)")
            }
        }
    }
}

struct BoardView: View {
    @StateObject var boardViewModel = BoardViewModel()
    @EnvironmentObject var gameViewModel: GameViewModel
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
    let boardSize: Double
    
    
    init(size: Double) {
        self.boardSize = size
    }
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .frame(width: boardSize + 1, height: boardSize + 1)
                .foregroundColor(Color("boardFrameColor"))
            
            Rectangle()
                .frame(width: boardSize, height: boardSize)
                .foregroundColor(Color("boardColor"))
            
            
            
            
            VStack(spacing:2) {
                HStack(spacing:5) {
                    VStack(spacing: boardSize/19) {
                        ForEach(0..<8) { i in
                            Text(String(8 - i))
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }.frame(height: boardSize*0.8)
                    HStack(spacing:1) {
                        ForEach((0..<8), id:\.self) { x in
                            VStack(spacing:1) {
                                ForEach((0..<8).reversed(), id:\.self) { y in
                                    TileView(tile: boardViewModel.board[y][x], tileSize: boardSize * 0.106, action: {self.tileAction(x: x, y: y)})
                                }
                            }
                        }
                    }
                }.offset(x:-7)
                HStack(spacing: boardSize/13) {
                    ForEach(0..<8) { i in
                        Text(letters[i])
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                }
            }.offset(y:10)
            
            if (boardViewModel.processingPromotion) {
                PromotionView(size: boardSize, piece: boardViewModel.promotedPiece!, action: {finishPromotion()})
                    .offset(y: boardSize * (boardViewModel.promotedPiece?.alliance == .White ? 0.62 : -0.62))
            }
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        
    }
    
    func finishPromotion() {
        boardViewModel.promotedPiece = nil
    }
    
    func tileAction(x: Int, y: Int) {
        let moveExecuted = boardViewModel.processTile(x: x, y: y, onTurn: gameViewModel.playersTurn)
        if moveExecuted {
            gameViewModel.nextTurn()
        }
        gameViewModel.gameOver = boardViewModel.gameOver
    }
}

struct TileView: View {
    @ObservedObject var tile: Tile
    let tileSize: Double
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(decideTileColor())
                .frame(width: tileSize, height: tileSize)
            if let pieceOnTile = tile.piece {
                Image(pieceOnTile.pieceImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: tileSize, height: tileSize, alignment: .center)
            }
            
            Circle()
                .foregroundColor(.green)
                .frame(width: tile.isTargetTile && tile.isEmpty ? tileSize * 0.6 : 0, height: tile.isTargetTile && tile.isEmpty ? tileSize * 0.6 : 0)
        }
        .onTapGesture {
            withAnimation(.spring()) {
                action()
            }
        }
    }
    
    
    func decideTileColor() -> Color {
        if (tile.isTargetTile) {
            if (!tile.isEmpty) {
                return Color.red
            }
        }
        
        return Color((tile.x + tile.y) % 2 == 0 ? "darkTileColor" : "lightTileColor")
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
