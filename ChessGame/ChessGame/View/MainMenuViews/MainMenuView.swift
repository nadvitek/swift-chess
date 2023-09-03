//
//  MainMenuView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import SwiftUI
import Firebase

let matches = [Game(id: "1", date: Date(timeIntervalSince1970: 1692812969), opponent: "Firecracker", alliance: .White, state: .Win),
               Game(id: "2", date: Date(timeIntervalSince1970: 1692812600), opponent: "Miken", alliance: .White, state: .Lose),
               Game(id: "3", date: Date(timeIntervalSince1970: 1692812769), opponent: "Aham", alliance: .Black, state: .Win),
               Game(id: "4", date: Date(timeIntervalSince1970: 1692811969), opponent: "Firecracker", alliance: .Black, state: .Draw),
               Game(id: "5", date: Date(timeIntervalSince1970: 1692812369), opponent: "Ter", alliance: .White, state: .Lose)]

//MARK: - This struct is kinda a mess, no time for refactoring, sorry.

struct MainMenuView: View {
    @StateObject var accountManager = AccountManager()
    @StateObject var gameSettings = GameSettings()
    @StateObject var mainMenuAnimator = MainMenuAnimator()
    
    let newAcc: Bool
    let email: String
    
    var body: some View {
        if (gameSettings.gameStarted) {
            GameView().environmentObject(gameSettings)
        } else {
            mainMenu
        }
        
    }
    
    var mainMenu: some View {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                mainMenuAnimator.infoViewShown = true
                            }
                        Spacer()
                        Text("Welcome \(accountManager.account.nickname)")
                            .font(.getFont(of: 20))
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                mainMenuAnimator.setNicknameView = true
                            }
                    }.padding()
                        .disabled(mainMenuAnimator.bgDisabled())
                    HStack {
                        ButtonView(text: "Single Player", action: {mainMenuAnimator.singlePlayerSelected = true})
                        ButtonView(text: "Multi Player", action: {mainMenuAnimator.multiPlayerSelected = true})
                        ButtonView(text: "Custom Board", action: {mainMenuAnimator.customBoardSelected = true})
                    }.disabled(mainMenuAnimator.bgDisabled())
                    Text("Match History (Preview)")
                        .font(.getFont(of: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    if (accountManager.matchHistory.isEmpty) {
                        Text("No games played yet.")
                            .font(.getFont(of: 20))
                            .frame(height: 500)
                    } else {
                        ScrollView(.vertical, showsIndicators: false, content: {
                            ForEach(accountManager.matchHistory) { game in
                                HistoryItemView(game: game)
                            }
                        })
                    }
                }.padding(.all, 3)
                    .blur(radius: (mainMenuAnimator.bgDisabled()) ? 7 : 0)
                if (mainMenuAnimator.setNicknameView) {
                    DialogView(height: 210, spacing: 20, headline: MainMenuTexts.nicknameHeadline, primaryButtonText: "Save", primaryButtonFunc: didSetNickname, textFieldText: MainMenuTexts.textFieldName).offset(y: 30)
                        .environmentObject(mainMenuAnimator)
                        .environmentObject(accountManager)
                }
                if (mainMenuAnimator.multiPlayerSelected) {
                    DialogView(height: 210, spacing: 20, headline: MainMenuTexts.multiplayerHeadline, primaryButtonText: "Ok", primaryButtonFunc: {mainMenuAnimator.multiPlayerSelected = false}).offset(y: 30)
                        .environmentObject(mainMenuAnimator)
                        .environmentObject(accountManager)
                }
                if (mainMenuAnimator.customBoardSelected) {
                    DialogView(height: 210, spacing: 20, headline: MainMenuTexts.customBoardHeadline, primaryButtonText: "Ok", primaryButtonFunc: {mainMenuAnimator.customBoardSelected = false})
                        .environmentObject(mainMenuAnimator)
                        .environmentObject(accountManager)
                }
                if (mainMenuAnimator.singlePlayerSelected) {
                    DialogView(height: 280, spacing: 20, headline: MainMenuTexts.gameParametersHeadline, primaryButtonText: "Play", primaryButtonFunc: playGame, secondaryButtonText: "Back",secondaryButtonFunc: {mainMenuAnimator.singlePlayerSelected = false}, toggle: true)
                        .environmentObject(mainMenuAnimator)
                        .environmentObject(accountManager)
                }
                if (mainMenuAnimator.infoViewShown) {
                    DialogView(height: 240, spacing: 10, headline: MainMenuTexts.infoHeadline, primaryButtonText: "Ok", primaryButtonFunc: {mainMenuAnimator.infoViewShown = false}).offset(y: 6)
                        .environmentObject(mainMenuAnimator)
                        .environmentObject(accountManager)
                }
            }.onAppear {
                setup()
            }
    }
    
    func setup() {
        mainMenuAnimator.setNicknameView = newAcc
        accountManager.account.email = email
        if !newAcc {
            accountManager.fetchData()
        } else {
            accountManager.addAccount()
        }
    }
    
    func didSetNickname() {
        if !accountManager.account.nickname.isEmpty {
            mainMenuAnimator.setNicknameView.toggle()
            accountManager.saveAccountNickname()
        }
    }
    
    func playGame() {
        mainMenuAnimator.singlePlayerSelected = false
        gameSettings.playersAlliance = mainMenuAnimator.blackPlayerChosen ? .Black : .White
        if (mainMenuAnimator.aiChosen) {
            gameSettings.gameType = .Bot
            if mainMenuAnimator.blackPlayerChosen {
                gameSettings.whitePlayerName = "Bot"
                gameSettings.blackPlayerName = accountManager.account.nickname
            } else {
                gameSettings.blackPlayerName = "Bot"
                gameSettings.whitePlayerName = accountManager.account.nickname
            }
        } else {
            gameSettings.gameType = .Offline
            if mainMenuAnimator.blackPlayerChosen {
                gameSettings.blackPlayerName = accountManager.account.nickname
            } else {
                gameSettings.whitePlayerName = accountManager.account.nickname
            }
        }
        gameSettings.gameStarted = true
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(newAcc: true, email: "haga")
    }
}
