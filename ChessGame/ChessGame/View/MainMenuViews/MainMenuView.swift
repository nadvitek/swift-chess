//
//  MainMenuView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 10.05.2023.
//

import SwiftUI
import Firebase
import OSLog

let matches = [Game(id: "1", date: Date(timeIntervalSince1970: 1692812969), whitePlayer: "Firecracker", blackPlayer: "Jennky", result: .WhiteWin),
               Game(id: "2", date: Date(timeIntervalSince1970: 1692812600), whitePlayer: "Jennky", blackPlayer: "Miken", result: .BlackWin),
               Game(id: "3", date: Date(timeIntervalSince1970: 1692812769), whitePlayer: "Jennky", blackPlayer: "Aham", result: .BlackWin),
               Game(id: "4", date: Date(timeIntervalSince1970: 1692811969), whitePlayer: "Firecracker", blackPlayer: "Jennky", result: .Draw),
               Game(id: "5", date: Date(timeIntervalSince1970: 1692812369), whitePlayer: "Jennky", blackPlayer: "Ter", result: .BlackWin)]

struct MainMenuView: View {
    @StateObject var accountManager = AccountManager()
    @StateObject var gameSettings = GameSettings()
    @StateObject var mainMenuAnimator = MainMenuAnimator()
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @Binding var colorSchemeLight: Bool
    
    let logger = Logger(subsystem: "com.nademvit.ChessGame", category: "LogInView")
    
    let newAcc: Bool
    let email: String
    
    var body: some View {
        if (gameSettings.gameStarted) {
            GameView().environmentObject(gameSettings)
        } else {
            mainMenu.preferredColorScheme(colorSchemeLight ? .light : .dark)
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
                                mainMenuAnimator.playerOptionsView = true
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
                        }).ignoresSafeArea()
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
                    DialogView(height: 210, spacing: 20, headline: MainMenuTexts.customBoardHeadline, primaryButtonText: "Ok", primaryButtonFunc: {mainMenuAnimator.customBoardSelected = false}).offset(y: 30)
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
                if (mainMenuAnimator.playerOptionsView) {
                    DialogView(height: 210, spacing: 20, headline: MainMenuTexts.playerOptions, primaryButtonText: "Log out", primaryButtonFunc: {loginViewModel.completionSuccesful = false}, secondaryButtonText: "Back", secondaryButtonFunc: {mainMenuAnimator.playerOptionsView = false}, colorSchemeChange: true).offset(y: 30)
                        .environmentObject(mainMenuAnimator)
                        .environmentObject(accountManager)
                }
            }.onAppear {
                setup()
            }
    }
    
    func saveColorScheme() {
        let schemeModel = SchemeModel(colorScheme: colorSchemeLight ? "light" : "dark")
        if let encodedData = try? JSONEncoder().encode(schemeModel) {
            UserDefaults.standard.set(encodedData, forKey: "color_scheme")
            logger.debug("New Color Scheme \(schemeModel.colorScheme) saved.")
        } else {
            logger.error("Data of SchemeModel couldn't be encoded.")
        }
    }
    
    func setup() {
        mainMenuAnimator.colorSchemeLight = colorSchemeLight
        mainMenuAnimator.schemeFunc = changeColorScheme
        if (gameSettings.gameResult == .None) {
            mainMenuAnimator.setNicknameView = newAcc
            accountManager.account.email = email
            if !newAcc {
                accountManager.fetchData()
            } else {
                accountManager.account.nickname = ""
                accountManager.addAccount()
            }
        } else {
            accountManager.saveGame(settings: gameSettings)
            gameSettings.gameResult = .None
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
                gameSettings.whitePlayerName = MainMenuTexts.defaultWhitePlayer
            } else {
                gameSettings.whitePlayerName = accountManager.account.nickname
                gameSettings.blackPlayerName = MainMenuTexts.defaultBlackPlayer
            }
        }
        gameSettings.gameStarted = true
    }
    
    func changeColorScheme() {
        self.colorSchemeLight.toggle()
        saveColorScheme()
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainMenuView(colorSchemeLight: .constant(true), newAcc: false, email: "haga")
                .environmentObject(LoginViewModel())
            MainMenuView(colorSchemeLight: .constant(false), newAcc: true, email: "haga")
                .environmentObject(LoginViewModel())
        }
    }
}
