//
//  LogInView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 12.08.2023.
//

import SwiftUI
import Firebase
import _AuthenticationServices_SwiftUI

/// This struct takes care of User registration or logging in process
/// It works with the Firebase Database
///
/// > Warning: The Sign in with Apple doesn't react, because I haven't
/// > signed up in the Apple Developer program yet. The Sign in with
/// > Google is not implemented too.

struct LogInView: View {
    @StateObject var loginViewModel = LoginViewModel()
    
    @State var colorSchemeLight = true
    
    init() {
        getColorScheme()
    }
    
    var body: some View {
        if loginViewModel.completionSuccesful {
            MainMenuView(colorSchemeLight: $colorSchemeLight, newAcc: !loginViewModel.logInView, email: loginViewModel.email)
                .preferredColorScheme(colorSchemeLight ? .light : .dark)
                .environmentObject(loginViewModel)
        } else {
            loginView.preferredColorScheme(colorSchemeLight ? .light : .dark)
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
                        .offset(y: loginViewModel.logInView ? -170 : -100)
                    
                    
                    
                    TextField("Email", text: $loginViewModel.email)
                        .font(.getFont(of: 25))
                        .placeholder(when: loginViewModel.email.isEmpty) {
                            Text("Email")
                                .font(.getFont(of: 25))
                                .foregroundColor(.gray)
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                    
                    SecureField("Password", text: $loginViewModel.password)
                        .font(.getFont(of: 25))
                        .placeholder(when: loginViewModel.password.isEmpty) {
                            Text("Password")
                                .font(.getFont(of: 25))
                                .foregroundColor(.gray)
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                    
                    if (!loginViewModel.logInView) {
                        
                        
                        SignInWithAppleButton { request in
                            //
                        } onCompletion: { result in
                            //
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .fontWeight(.bold)
                        .cornerRadius(15)
                        .signInWithAppleButtonStyle(colorSchemeLight ? .white : .black)
                        .shadow(radius: 5)
                        
                        
                        Button {
                            //
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundColor(colorSchemeLight ? .black : .white)
                                .overlay {
                                    HStack {
                                        Image("google")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                        Text("Sign in with Google")
                                            .foregroundColor(colorSchemeLight ? .white : .black)
                                            .font(.system(size: 18))
                                            .fontWeight(.semibold)
                                    }
                                }
                                .shadow(radius: 5)
                        }
                        
                    }
                    
                    
                    Button {
                        loginViewModel.logInView ? logIn() : signUp()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.text)
                            .frame(width: 200, height: 50)
                            .overlay {
                                Text(loginViewModel.logInView ? "Log in" : "Sign up")
                                    .foregroundColor(colorSchemeLight ? .white : .black)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                            }
                            .shadow(radius: 5)
                            .offset(y: 40)
                    }
                    
                    Text(loginViewModel.logInView ? "Don't have an account? Sign up" : "Already have an account? Log in")
                        .foregroundColor(.text)
                        .font(.getFont(of: 18))
                        .offset(y: 100)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.1)) {
                                loginViewModel.logInView.toggle()
                            }
                        }
                    
                    
                    
                }.padding(.horizontal)
                    .alert(isPresented: $loginViewModel.errorOccurred) {
                        Alert(title: Text("Error"), message: Text(loginViewModel.errorMessage), dismissButton: .default(Text("OK"), action: {
                            loginViewModel.errorOccurred = false
                        }))
                    }
            }
        }
    }
    
    func getColorScheme() {
        guard let data = UserDefaults.standard.data(forKey: "color_scheme") else {
            print("Data were not loaded.")
            return
        }
        
        guard let decodedData = try? JSONDecoder().decode(SchemeModel.self, from: data) else {
            print("Scheme wasn't decoded.")
            return
        }
        
        colorSchemeLight = decodedData.colorScheme == "light" ? true : false
    }
    
    
    func signUp() {
        Auth.auth().createUser(withEmail: loginViewModel.email, password: loginViewModel.password) { result, error in
            if error != nil {
                loginViewModel.errorMessage = error!.localizedDescription
                loginViewModel.errorOccurred = true
                return
            }
            withAnimation(.easeIn(duration: 2.0)){
                loginViewModel.completionSuccesful = true
            }
        }
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: loginViewModel.email, password: loginViewModel.password) { result, error in
            if error != nil {
                loginViewModel.errorMessage = error!.localizedDescription
                loginViewModel.errorOccurred = true
                return
            }
            
            withAnimation(.easeIn(duration: 2.0)){
                loginViewModel.completionSuccesful = true
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}


