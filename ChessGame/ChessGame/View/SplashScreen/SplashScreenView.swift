//
//  SplashScreenView.swift
//  ChessGame
//
//  Created by Vít Nademlejnský on 05.08.2023.
//

import SwiftUI

struct SplashScreenView: View {
    @State var firstPhase = false
    @State var secondPhase = false
    @State var thirdPhase = false
    
    
    var body: some View {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                splashScreen.opacity(secondPhase || thirdPhase ? 0 : 1.0)
                Color(.black).opacity(secondPhase ? 1.0 : 0)
                    .edgesIgnoringSafeArea(.all)
                LogInView().opacity(thirdPhase ? 1.0 : 0)
                    .edgesIgnoringSafeArea(.all)
            }
    }
    
    var splashScreen: some View {
        VStack {
            ZStack {
                Image("mill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 240)
                Image("airscrew")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, alignment: .center)
                    .rotationEffect(Angle(degrees: firstPhase ? 310 : 40))
                    .offset(x: 45, y: 23)
                Image("cloud")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45)
                    .offset(x: firstPhase ? -30 : -75)
                Image("cloud")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45)
                    .offset(x: firstPhase ? 50 : -50, y: -130)
            }
            Image("text")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 50)
                
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 3.5)) {
                        firstPhase.toggle()
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false) {_ in
                    withAnimation(.easeIn(duration: 1.0)) {
                        secondPhase = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
                    withAnimation(.easeIn(duration: 1.0)) {
                        secondPhase = false
                        thirdPhase = true
                    }
                }
            }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
