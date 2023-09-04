//
//  LoginViewModel.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 04.09.2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var errorOccurred = false
    @Published var logInView = false
    @Published var completionSuccesful = false
    
    @Published var errorMessage: String = "Error occurred, please try again"
}
