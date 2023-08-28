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

struct MainMenuView: View {
    @State var nickname = ""
    @State var matchHistory: [Game] = matches
    @StateObject var accountManager = AccountManager()
    @State var setNicknameView: Bool
    @StateObject var gameSettings = GameSettings()
    @State var multiPlayerSelected = false
    @State var customBoardSelected = false
    @State var singlePlayerSelected = false
    @State var blackPlayerChosen = true
    @State var aiChosen = true
    @State var infoViewShown = false
    
    init(email: String, newAccount: Bool) {
        setNicknameView = newAccount
        accountManager.account.email = email
        if (!newAccount) {
            accountManager.fetchData()
        }
    }
    
    var body: some View {
        if (gameSettings.gameStarted) {
            GameView().environmentObject(gameSettings)
        } else {
            mainMenu
        }
        
    }
    
    var mainMenu: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                infoViewShown = true
                            }
                        Spacer()
                        Text("Welcome \(accountManager.account.nickname)")
                            .font(.getFont(of: 20))
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                setNicknameView = true
                            }
                    }.padding()
                        .disabled(setNicknameView || multiPlayerSelected || singlePlayerSelected || customBoardSelected)
                    HStack {
                        RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.button)
                                .frame(width: 100, height: 70)
                                .overlay {
                                    Text("Single Player")
                                        .foregroundColor(.black)
                                        .font(.getFont(of: 22))
                                }
                                .onTapGesture {
                                    singlePlayerSelected = true
                                }
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.button)
                            .frame(width: 100, height: 70)
                            .overlay {
                                Text("Multi Player")
                                    .foregroundColor(.black)
                                    .font(.getFont(of: 22))
                                    .multilineTextAlignment(.center)
                            }
                            .onTapGesture {
                                multiPlayerSelected = true
                            }
                        
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.button)
                            .frame(width: 100, height: 70)
                            .overlay {
                                Text("Custom Board")
                                    .foregroundColor(.black)
                                    .font(.getFont(of: 22))
                                    .multilineTextAlignment(.center)
                            }
                            .onTapGesture {
                                customBoardSelected = true
                            }
                    }.disabled(setNicknameView || multiPlayerSelected || singlePlayerSelected || customBoardSelected)
                    Text("Match History")
                        .font(.getFont(of: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    if (matchHistory.isEmpty) {
                        Text("No games played yet.")
                            .font(.getFont(of: 20))
                            .frame(height: 500)
                    } else {
                        ScrollView(.vertical, showsIndicators: false, content: {
                            ForEach(matchHistory) { game in
                                HistoryItemView(game: game)
                            }
                        })
                    }
                }.padding(.all, 3)
                    .blur(radius: (setNicknameView || multiPlayerSelected || singlePlayerSelected || customBoardSelected) ? 7 : 0)
                if (setNicknameView) {
                    setNickNameView.offset(y: 30)
                }
                if (multiPlayerSelected) {
                    multiPlayerSelectedView.offset(y: 30)
                }
                if (customBoardSelected) {
                    customBoardSelectedView
                }
                if (singlePlayerSelected) {
                    gameParameters
                }
                if (infoViewShown) {
                    infoView
                }
            }
        }
    }
    
    var setNickNameView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 260, height: 210)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 200)
                .foregroundColor(.button)
            VStack (spacing: 20) {
                Text("Set your game name:")
                    .foregroundColor(.black)
                    .font(.getFont(of: 20))
                VStack (spacing: 5) {
                    TextField("Your Name", text: $nickname)
                        .font(.getFont(of: 25))
                        .foregroundColor(.black)
                        .placeholder(when: nickname.isEmpty) {
                            Text("Your Name")
                                .foregroundColor(.gray)
                                .font(.getFont(of: 25))
                        }
                        .offset(x:90)
                    Rectangle()
                        .frame(width: 200, height: 1)
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: 150, height: 50)
                    .overlay {
                        Text("Save")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                    }
                    .shadow(radius: 5)
                    .onTapGesture {
                        didSetNickname()
                    }
                
            }
        }
    }
    
    var multiPlayerSelectedView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 260, height: 210)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 200)
                .foregroundColor(.button)
            VStack (spacing: 20) {
                Text("Multi Player is not implemented yet.")
                    .foregroundColor(.black)
                    .font(.getFont(of: 20))
                    .frame(maxWidth: 230)
                    .multilineTextAlignment(.center)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: 150, height: 50)
                    .overlay {
                        Text("Ok")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                    }
                    .shadow(radius: 5)
                    .onTapGesture {
                        multiPlayerSelected = false
                    }
                
            }
        }
    }
    
    var customBoardSelectedView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 260, height: 210)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 200)
                .foregroundColor(.button)
            VStack (spacing: 20) {
                Text("Custom Board is not implemented yet.")
                    .foregroundColor(.black)
                    .font(.getFont(of: 20))
                    .frame(maxWidth: 230)
                    .multilineTextAlignment(.center)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: 150, height: 50)
                    .overlay {
                        Text("Ok")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                    }
                    .shadow(radius: 5)
                    .onTapGesture {
                        customBoardSelected = false
                    }
                
            }
        }
    }
    
    func didSetNickname() {
        if !nickname.isEmpty {
            setNicknameView.toggle()
            accountManager.account.nickname = nickname
        }
    }
    
    var gameParameters: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 260, height: 280)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 270)
                .foregroundColor(.button)
            VStack (spacing: 20) {
                Text("Game Parameters")
                    .foregroundColor(.black)
                    .font(.getFont(of: 25))
                    .frame(maxWidth: 230)
                    .multilineTextAlignment(.center)
                VStack {
                    Text("Your Color:")
                        .font(.getFont(of: 20))
                        .foregroundColor(.black)
                    Toggle("", isOn: $blackPlayerChosen).frame(maxWidth: 150)
                        .toggleStyle(ColoredToggleStyle(label: blackPlayerChosen ? "Black" : "White", onColor: .black, offColor: .white, thumbColor: blackPlayerChosen ? .white : .black))
                    Toggle("", isOn: $aiChosen).frame(maxWidth: 150)
                        .toggleStyle(ColoredToggleStyle(label: aiChosen ? "vs AI" : "Local", onColor: .black, offColor: .white, thumbColor: aiChosen ? .white : .black))
                    
                }.frame(maxWidth: 230)
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Back")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            singlePlayerSelected = false
                        }
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Play")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            playGame()
                        }
                }
                
            }
        }
    }
    
    var infoView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 260, height: 240)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 230)
                .foregroundColor(.button)
            VStack (spacing: 10) {
                Text("This application was developed by Vít Nademlejnský as a part of his portfolio and a demonstration of his skills.")
                    .foregroundColor(.black)
                    .font(.getFont(of: 20))
                    .frame(maxWidth: 230)
                    .multilineTextAlignment(.center)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: 150, height: 50)
                    .overlay {
                        Text("Ok")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                    }
                    .shadow(radius: 5)
                    .onTapGesture {
                        infoViewShown = false
                    }
                
            }
        }.offset(y: 6)
    }
    
    func playGame() {
        gameSettings.playersAlliance = blackPlayerChosen ? .Black : .White
        if (aiChosen) {
            gameSettings.gameType = .Bot
            if blackPlayerChosen {
                gameSettings.whitePlayerName = "Bot"
                gameSettings.blackPlayerName = nickname
            } else {
                gameSettings.blackPlayerName = "Bot"
                gameSettings.whitePlayerName = nickname
            }
        } else {
            gameSettings.gameType = .Offline
            if blackPlayerChosen {
                gameSettings.blackPlayerName = nickname
            } else {
                gameSettings.whitePlayerName = nickname
            }
        }
        gameSettings.gameStarted = true
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(email: "haga", newAccount: false)
    }
}
