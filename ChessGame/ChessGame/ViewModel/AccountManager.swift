//
//  AccountManager.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 26.08.2023.
//

import Foundation
import Firebase


class AccountManager: ObservableObject {
    @Published var account: Account = Account(email: "", nickname: "")
    @Published var matchHistory: [Game] = []
    
    let db = Firestore.firestore()
    
    func saveAccountNickname() {
        let accounts = db.collection("accounta")
        let myAccount = accounts.whereField("email", isEqualTo: account.email)
        myAccount.setValue(account.nickname, forKey: "nickname")
    }
    
    func addAccount() {
        let accounts = db.collection("accounta")
        accounts.addDocument(data: account.dataFormat)
    }
    
    func fetchData() {
        findAccount()
        findMatchHistory()
    }
    
    func findAccount() {
        let accounts = db.collection("accounts")
        accounts.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let dbEmail = data["email"] as? String ?? "mail"
                    
                    guard dbEmail == self.account.email else {
                        continue
                    }
                    
                    let id = data["id"] as? String ?? "1"
                    let name = data["nickname"] as? String ?? "name"
                    
                    self.account.nickname = name
                    self.account.id = id
                    return
                }
            }
        }
    }
    
    func findMatchHistory() {
        let games = db.collection("games")
        let whiteGames = games.whereField("whitePlayer", isEqualTo: account.email)
        let blackGames = games.whereField("blackPlayer", isEqualTo: account.email)
                
        whiteGames.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? "1"
                    let blackPlayer = data["blackPlayer"] as? String ?? "a"
                    let score = data["score"] as? Int ?? 1
                    let date = data["date"] as? Date ?? Date()
                    
                    var gameState: GameState
                    switch score {
                    case 1:
                        gameState = .Win
                    case 2:
                        gameState = .Lose
                    case 3:
                        gameState = .Draw
                    default:
                        gameState = .Win
                    }
                    
                    self.matchHistory.append(Game(id: id, date: date, opponent: blackPlayer, alliance: .White, state: gameState))
                }
            }
        }
        
        blackGames.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? "1"
                    let whitePlayer = data["whitePlayer"] as? String ?? "a"
                    let score = data["score"] as? Int ?? 1
                    let date = data["date"] as? Date ?? Date()
                    
                    var gameState: GameState
                    switch score {
                    case 1:
                        gameState = .Lose
                    case 2:
                        gameState = .Win
                    case 3:
                        gameState = .Draw
                    default:
                        gameState = .Win
                    }
                    
                    self.matchHistory.append(Game(id: id, date: date, opponent: whitePlayer, alliance: .Black, state: gameState))
                }
            }
        }
    }
}
