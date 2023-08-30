//
//  GameView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 22.05.2023.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel = GameViewModel()
    @EnvironmentObject var gameSettings: GameSettings
    
    var body: some View {
        gameView
    }
    
    var gameView: some View {
        GeometryReader { geo in
                Rectangle()
                    .fill()
                    .ignoresSafeArea()
                    .foregroundColor(Color("backgroundColor"))
            ZStack {
                VStack() {
                    HStack {
                        Text(gameViewModel.isReversed ?
                             gameSettings.whitePlayerName : gameSettings.blackPlayerName)
                            .font(.getFont(of: 30))
                        Spacer()
                        Text(gameViewModel.isReversed ?
                             gameViewModel.showWhiteTime() : gameViewModel.showBlackTime())
                            .font(.getFont(of: 30))
                    }.padding()
                    
                    
                    
                    
                    ZStack {
                        BoardView(size: geo.size.width * 0.9)
                            .environmentObject(gameViewModel)
                            .environmentObject(gameSettings)
                            .onAppear {
                                setRightView()
                            }
                        OptionsButtonView(size: geo.size.width * 0.15, alliance: gameViewModel.isReversed ? .White : .Black)
                            .environmentObject(gameViewModel)
                        OptionsButtonView(size: geo.size.width * 0.15, alliance: gameViewModel.isReversed ? .Black : .White)
                            .environmentObject(gameViewModel)
                    }
                    
                    
                    
                    
                    HStack {
                        Text(gameViewModel.isReversed ?
                             gameViewModel.showBlackTime() : gameViewModel.showWhiteTime())
                            .font(.getFont(of: 30))
                        Spacer()
                        Text(gameViewModel.isReversed ?  gameSettings.blackPlayerName : gameSettings.whitePlayerName)
                            .font(.getFont(of: 30))
                    }.padding()
                }.disabled(gameViewModel.gameOver)
                .blur(radius: gameViewModel.showGameOver ? 7 : 0)
                if(gameViewModel.showGameOver) {
                    gameOverView
                }
                if(gameViewModel.drawOffered) {
                    drawOfferedView
                }
                if (gameViewModel.gameOver) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.button)
                        .frame(width: 150, height: 50)
                        .overlay {
                            Text("Return to Main Menu")
                                .foregroundColor(.black.opacity(0.8))
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            gameSettings.gameStarted = false
                        }
                        .offset(x: -100, y: 220)
                        .blur(radius: gameViewModel.showGameOver ? 7 : 0)
                }
            }
        }
    }
    
    var gameOverView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 340, height: 210)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 330, height: 200)
                .foregroundColor(.button)
            VStack (spacing: 70) {
                Text("\(gameViewModel.playersTurn.switchAlliance.description) Player Wins!")
                    .foregroundColor(.black)
                    .font(.getFont(of: 25))
                
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.black)
                        .frame(width: 150, height: 50)
                        .overlay {
                            Text("Show Board")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            gameViewModel.showGameOver = false
                    }
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.black)
                        .frame(width: 150, height: 50)
                        .overlay {
                            Text("Return to Main Menu")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            gameSettings.gameStarted = false
                    }
                }
                
            }
        }
    }
    
    var drawOfferedView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 260, height: 210)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 200)
                .foregroundColor(.button)
            VStack (spacing: 70) {
                Text("Draw is not implemnted yet.")
                    .foregroundColor(.black)
                    .font(.getFont(of: 25))
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: 150, height: 50)
                    .overlay {
                        Text("Ok")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                    }
                    .shadow(radius: 5)
                    .onTapGesture {
                        gameViewModel.drawOffered = false
                    }
                
            }
        }
    }
    
    func setRightView() {
        if gameSettings.gameType == .Bot && gameSettings.playersAlliance == .Black{
            gameViewModel.reverse()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameSettings())
    }
}
