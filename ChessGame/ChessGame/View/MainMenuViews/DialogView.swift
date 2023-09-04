//
//  DialogView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 03.09.2023.
//

import SwiftUI

struct DialogView: View {
    let height: CGFloat //210, last - 240, single player 280
    let spacing: CGFloat // 20, last 10
    let headline: String // font 25 game param
    let primaryButtonText: String
    let primaryButtonFunc: () -> Void
    let secondaryButtonText: String
    let secondaryButtonFunc: (() -> Void)
    let textFieldText: String
    let toggle: Bool
    let colorSchemeChange: Bool
    
    @EnvironmentObject var animator: MainMenuAnimator
    @EnvironmentObject var accountManager: AccountManager
    
    init(height: CGFloat, spacing: CGFloat, headline: String, primaryButtonText: String, primaryButtonFunc: @escaping () -> Void, secondaryButtonText: String = "", secondaryButtonFunc: @escaping () -> Void = {}, textFieldText: String = "", toggle: Bool = false, colorSchemeChange: Bool = false) {
        self.height = height
        self.spacing = spacing
        self.headline = headline
        self.primaryButtonText = primaryButtonText
        self.primaryButtonFunc = primaryButtonFunc
        self.secondaryButtonText = secondaryButtonText
        self.secondaryButtonFunc = secondaryButtonFunc
        self.textFieldText = textFieldText
        self.toggle = toggle
        self.colorSchemeChange = colorSchemeChange
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 260, height: height)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: height - 10)
                .foregroundColor(.button)
            VStack(spacing: spacing) {
                Text(headline)
                    .foregroundColor(.black)
                    .font(.getFont(of: 20))
                    .frame(maxWidth: 230)
                    .multilineTextAlignment(.center)
                if !textFieldText.isEmpty {
                    VStack (spacing: 5) {
                        TextField(textFieldText, text: $accountManager.account.nickname)
                            .font(.getFont(of: 25))
                            .foregroundColor(.black)
                            .placeholder(when: accountManager.account.nickname.isEmpty) {
                                Text(textFieldText)
                                    .foregroundColor(.gray)
                                    .font(.getFont(of: 25))
                            }
                            .offset(x:90)
                        Rectangle()
                            .frame(width: 200, height: 1)
                    }
                }
                toggles
                buttons
            }
        }
    }
    
    var buttons: some View {
        HStack {
            if !secondaryButtonText.isEmpty {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: 100, height: 50)
                    .overlay {
                        Text(secondaryButtonText)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .shadow(radius: 5)
                    .onTapGesture(perform: secondaryButtonFunc)
            }
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.black)
                    .frame(width: secondaryButtonText.isEmpty ? 150 : 100, height: 50)
                    .overlay {
                        Text(primaryButtonText)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                    }
                    .shadow(radius: 5)
                    .onTapGesture(perform: primaryButtonFunc)
        }
    }
    
    var toggles: some View {
        ZStack {
            if colorSchemeChange {
                Toggle("", isOn: $animator.colorSchemeLight).frame(maxWidth: 150)
                    .toggleStyle(ColoredToggleStyle(label: animator.colorSchemeLight ? "Light" : "Dark", onColor: .white, offColor: .black, thumbColor: animator.colorSchemeLight ? .black : .white))
            }
            if toggle {
                VStack {
                    Text("Your Color:")
                        .font(.getFont(of: 20))
                        .foregroundColor(.black)
                    Toggle("", isOn: $animator.blackPlayerChosen).frame(maxWidth: 150)
                        .toggleStyle(ColoredToggleStyle(label: animator.blackPlayerChosen ? "Black" : "White", onColor: .black, offColor: .white, thumbColor: animator.blackPlayerChosen ? .white : .black))
                    Toggle("", isOn: $animator.aiChosen).frame(maxWidth: 150)
                        .toggleStyle(ColoredToggleStyle(label: animator.aiChosen ? "vs AI" : "Local", onColor: .black, offColor: .white, thumbColor: animator.aiChosen ? .white : .black))
                    
                }.frame(maxWidth: 230)
            }
        }
    }
}

