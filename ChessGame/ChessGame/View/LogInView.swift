//
//  LogInView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 12.08.2023.
//

import SwiftUI
import Firebase
import _AuthenticationServices_SwiftUI

struct LogInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var errorOccurred = false
    @State var logInView = false
    
    @State var errorMessage: String = "Error occurred, please try again"
    
    @State var completionSuccesful = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if completionSuccesful {
            MainMenuView(email: email, newAccount: !logInView)
        } else {
            loginView
        }
    }
    
    var loginView: some View {
        ZStack {
            LinearGradient(colors: [.bg, Color.brown], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            ZStack {
                VStack(spacing: 20) {
                    Text("CzechMate")
                        .font(.getFont(of: 50))
                        .offset(y: logInView ? -170 : -100)
                    
                    
                    
                    TextField("Email", text: $email)
                        .font(.getFont(of: 25))
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .font(.getFont(of: 25))
                                .foregroundColor(.gray)
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                    
                    SecureField("Password", text: $password)
                        .font(.getFont(of: 25))
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .font(.getFont(of: 25))
                                .foregroundColor(.gray)
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                    
                    if (!logInView) {
                        
                        
                        SignInWithAppleButton { request in
                            //
                        } onCompletion: { result in
                            //
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .fontWeight(.bold)
                        .cornerRadius(15)
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                        .shadow(radius: 5)
                        
                        
                        Button {
                            //
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .overlay {
                                    HStack {
                                        Image("google")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                        Text("Sign in with Google")
                                            .foregroundColor(colorScheme == .light ? .white : .black)
                                            .font(.system(size: 18))
                                            .fontWeight(.semibold)
                                    }
                                }
                                .shadow(radius: 5)
                        }
                        
                    }
                    
                    
                    Button {
                        logInView ? logIn() : signUp()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.text)
                            .frame(width: 200, height: 50)
                            .overlay {
                                Text(logInView ? "Log in" : "Sign up")
                                    .foregroundColor(colorScheme == .light ? .white : .black)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                            }
                            .shadow(radius: 5)
                            .offset(y: 40)
                    }
                    
                    Text(logInView ? "Don't have an account? Sign up" : "Already have an account? Log in")
                        .foregroundColor(.text)
                        .font(.getFont(of: 18))
                        .offset(y: 100)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.1)) {
                                logInView.toggle()
                            }
                        }
                    
                    
                    
                }.padding(.horizontal)
                    .alert(isPresented: $errorOccurred) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK"), action: {
                            errorOccurred = false
                        }))
                    }
            }
        }
    }
    
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                errorMessage = error!.localizedDescription
                errorOccurred = true
            }
            
            withAnimation(.easeIn(duration: 2.0)){
                completionSuccesful = true
            }
        }
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                errorMessage = error!.localizedDescription
                errorOccurred = true
            }
            
            withAnimation(.easeIn(duration: 2.0)){
                completionSuccesful = true
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
    }
}
