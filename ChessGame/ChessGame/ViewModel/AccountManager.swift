//
//  AccountManager.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 26.08.2023.
//

import Foundation
import Firebase
import OSLog

/// Manager for getting data from database of current user
class AccountManager: ObservableObject {
    @Published var account: Account = Account(email: "", nickname: "")
    @Published var matchHistory: [Game] = []
    let logger = Logger(subsystem: "com.nademvit.ChessGameTests", category: "AccountManager")
    
    let db = Firestore.firestore()
    
    func saveAccountNickname() {
        let account = db.collection("accounts").document(account.email)
        account.setData(self.account.dataFormat)
    }
    
    func addAccount() {
        let accounts = db.collection("accounts").document(account.email)
        accounts.setData(account.dataFormat) { error in
            if let error = error {
                self.logger.error("Couldn't add an account to the database.")
                print(error.localizedDescription)
                return
            }
            
            self.logger.info("Account added to the database.")
        }
        //accounts.addDocument(data: account.dataFormat)
    }
    
    func fetchData() {
        findAccount()
        findMatchHistory()
        logger.info("Fetching data completed.")
    }
    
    func findAccount() {
        let accounts = db.collection("accounts")
        accounts.getDocuments { snapshot, error in
            guard error == nil else {
                self.logger.error("Getting accounts from database failed")
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
                    self.logger.info("Account found.")
                    
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
                self.logger.error("Getting match history where user was white player from database failed.")
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
                self.logger.info("Match history where the user was white player loaded.")
            }
        }
        
        blackGames.getDocuments { snapshot, error in
            guard error == nil else {
                self.logger.error("Getting match history where user was black player from database failed.")
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
                self.logger.info("Match history where the user was black player loaded.")
            }
        }
    }
}
