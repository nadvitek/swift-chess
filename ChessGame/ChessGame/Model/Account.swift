//
//  Account.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 24.08.2023.
//

import SwiftUI

struct Account: Identifiable {
    var id: String
    var email: String
    var nickname: String
    var dataFormat: [String: Any] {
        get {
            return ["email" : email,
                    "id": id,
                    "nickname": nickname]
        }
    }
    
    init(id: String = UUID().uuidString, email: String, nickname: String) {
        self.id = id
        self.email = email
        self.nickname = nickname
    }
}
    
