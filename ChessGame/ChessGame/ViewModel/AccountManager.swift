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
    @Published var account: Account = Account(email: "", nickname: "user")
    @Published var matchHistory: [Game] = []
    let logger = Logger(subsystem: "com.nademvit.ChessGame", category: "AccountManager")
    
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
    }
    
    func saveGame(settings: GameSettings) {
        let game = Game(date: Date(), whitePlayer: settings.playersAlliance == .White ? account.email : settings.whitePlayerName, blackPlayer: settings.playersAlliance == .Black ? account.email : settings.blackPlayerName, result: settings.gameResult)
        let gameId = game.id
        let viewableGame = Game(id: gameId, date: Date(), whitePlayer: settings.playersAlliance == .White ? account.nickname : settings.whitePlayerName, blackPlayer: settings.playersAlliance == .Black ? account.nickname : settings.blackPlayerName, result: settings.gameResult)
        self.matchHistory.append(viewableGame)
        let gameData = db.collection("games").document(game.id)
        gameData.setData(game.dataFormat) { error in
            if let error = error {
                self.logger.error("Couldn't add game to the database.")
                print(error.localizedDescription)
                return
            }
            
            self.logger.info("Game added to the database.")
        }
    }
    
    func fetchData() {
        findAccount()
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
                    
                    break
                }
                self.findMatchHistory()
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
                    let blackPlayer = data["blackPlayer"] as? String ?? "black"
                    let score = data["result"] as? Int ?? 1
                    let date = (data["date"] as? Timestamp)?.dateValue()
                    
                    var result: GameResult
                    switch score {
                    case 1:
                        result = .WhiteWin
                    case 2:
                        result = .BlackWin
                    case 3:
                        result = .Draw
                    default:
                        result = .WhiteWin
                    }
                    
                    self.matchHistory.append(Game(id: id, date: date!, whitePlayer: self.account.nickname, blackPlayer: blackPlayer, result: result))
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
                    let score = data["result"] as? Int ?? 1
                    let date = (data["date"] as? Timestamp)?.dateValue()
                    
                    var result: GameResult
                    switch score {
                    case 1:
                        result = .WhiteWin
                    case 2:
                        result = .BlackWin
                    case 3:
                        result = .Draw
                    default:
                        result = .WhiteWin
                    }
                    
                    self.matchHistory.append(Game(id: id, date: date!, whitePlayer: whitePlayer, blackPlayer: self.account.nickname, result: result))
                }
                self.logger.info("Match history where the user was black player loaded.")
            }
        }
    }
}
