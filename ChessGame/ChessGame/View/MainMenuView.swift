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
    @State var matchHistory: [Game] = []
    @StateObject var accountManager = AccountManager()
    @State var setNicknameView: Bool
    @StateObject var gameSettings = GameSettings()
    
    init(email: String, newAccount: Bool) {
        setNicknameView = newAccount
        accountManager.account.email = email
        if (!newAccount) {
            accountManager.fetchData()
        }
    }
    
    
    
    var body: some View {
        if (gameSettings.gameStarted) {
            gameSettings.gameType == .Bot ? GameView(whitePlayer: nickname) : GameView(blackPlayer: nickname)
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
                        Spacer()
                        Text("Welcome \(accountManager.account.nickname)")
                            .font(.getFont(of: 20))
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }.padding()
                    HStack {
                        NavigationLink {
                            SinglePlayerOptions()
                                .environmentObject(gameSettings)
                        } label: {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.button)
                                .frame(width: 100, height: 70)
                                .overlay {
                                    Text("Single Player")
                                        .foregroundColor(.black)
                                        .font(.getFont(of: 22))
                                }
                        }
                        ButtonView(cornerRadius: 50, text: "Multi Player", textSize: 22)
                        ButtonView(cornerRadius: 50, text: "Custom Board", textSize: 22)
                    }
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
                if (setNicknameView) {
                    setNickNameView.offset(y: 30)
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
    
    func didSetNickname() {
        if !nickname.isEmpty {
            setNicknameView.toggle()
            accountManager.account.nickname = nickname
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(email: "haga", newAccount: false)
    }
}
