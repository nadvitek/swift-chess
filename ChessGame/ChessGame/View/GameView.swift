//
//  GameView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 22.05.2023.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel = GameViewModel()
    
    init(whitePlayer: String = "Player White", blackPlayer: String = "Player Black") {
        gameViewModel.whitePlayerName = whitePlayer
        gameViewModel.blackPlayerName = blackPlayer
    }
    
    var body: some View {
        GeometryReader { geo in
                Rectangle()
                    .fill()
                    .ignoresSafeArea()
                    .foregroundColor(Color("backgroundColor"))
            VStack() {
                HStack {
                    Text(gameViewModel.blackPlayerName)
                        .font(.custom("VarelaRound-Regular", size: 30))
                    Spacer()
                    Text(gameViewModel.showBlackTime())
                        .font(.custom("VarelaRound-Regular", size: 30))
                }.padding()
                
                OptionsButtonView(size: geo.size.width * 0.15, alliance: Alliance.Black)
                
                
                BoardView(size: geo.size.width * 0.9)
                    .environmentObject(gameViewModel)
                
                
                OptionsButtonView(size: geo.size.width * 0.15, alliance: Alliance.White)
                
                HStack {
                    Text(gameViewModel.showWhiteTime())
                        .font(.custom("VarelaRound-Regular", size: 30))
                    Spacer()
                    Text(gameViewModel.whitePlayerName)
                        .font(.custom("VarelaRound-Regular", size: 30))
                }.padding()
                
            }
            
            if(gameViewModel.gameOver) {
                Text("\(gameViewModel.playersTurn.switchAlliance.description) Player Wins! \(geo.size.width)")
            }
        }
    }
}

struct OptionsButtonView: View {
    @State var isSpread: Bool = false
    @State var iconsShowed: Bool = false
    let size: Double
    let alliance: Alliance
    
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 100)
                .foregroundColor(Color("boardColor"))
                .frame(width: isSpread ? size * 6 : size, height: size)
            if (iconsShowed) {
                Image(systemName: "flag.fill")
                    .resizable()
                    .frame(width: size/2, height: size/2)
                    .foregroundColor(Color.white)
                    .rotationEffect(.degrees(alliance == .White ? 180 : 0))
                    .offset(x: -135)
                
                Image(systemName: "flag.2.crossed.fill")
                    .resizable()
                    .frame(width: size/1.3, height: size/2)
                    .foregroundColor(Color.brown)
                    .rotationEffect(.degrees(alliance == .White ? 180 : 0))
                    .offset(x: -30)
                
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .resizable()
                    .frame(width: size/1.7, height: size/1.7)
                    .foregroundColor(Color.gray)
                    .rotationEffect(.degrees(alliance == .White ? 180 : 0))
                    .offset(x: 70)
            }
            
            Image(systemName: "chevron.backward")
                .resizable()
                .frame(width: size/3, height: size/2)
                .rotationEffect(.degrees(isSpread ? 0 : 180))
                .foregroundColor(Color("buttonColor"))
                .offset(x: isSpread ? size * 2.5 : 3)
                .onTapGesture {
                    withAnimation(.spring(response: 1.2, dampingFraction: 0.9, blendDuration: 0.7)) {
                        isSpread.toggle()
                    }
                    
                    if (!isSpread) {
                        iconsShowed.toggle()
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                            withAnimation(.spring()) {
                                iconsShowed.toggle()
                            }
                        }
                    }
                    
                }
        }.position(x: isSpread ? size * 2.5 : 0)
            .padding(50)
            .offset(y: alliance == Alliance.White ? -40 : -40)
            .rotationEffect(.degrees(alliance == .White ? 180 : 0))
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
        GameView(whitePlayer: "A", blackPlayer: "B")
    }
}
