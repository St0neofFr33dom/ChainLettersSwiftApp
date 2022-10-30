//
//  TitleView.swift
//  LetterChain
//
//  Created by Christophe on 30/10/2022.
//

import SwiftUI

struct TitleView: View {
    
    @Environment(\.verticalSizeClass) var sizeClass
    
    @Binding var session: GameLogic
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color("Top"), Color("Bottom")]), startPoint: /*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Spacer()
                if sizeClass == .regular{
                    // || PORTRAIT ||
                    Text("Welcome To").modifier(CustomText()).font(.system(size: 36))
                    Text("Chain \n \u{1F517} \n Letters")
                        .font(.system(size: 72))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .modifier(CustomText())
                } else {
                    // || LANDSCAPE ||
                    Text("Welcome To").modifier(CustomText()).font(.system(size: 36))
                    Text("Chain \u{1F517} Letters")
                        .font(.system(size: 72))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .modifier(CustomText())
                        .frame(maxWidth:.infinity)
                }
                // || END OF DIFFERENCES ||
                Spacer()
                Text("High Score: " + String(session.highScore)).modifier(CustomText()).font(.system(size: 36))
                Spacer()
                Button("Start Game"){session.startGame()} .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).modifier(CustomText()).background(RoundedRectangle(cornerRadius: 40).foregroundColor(Color("Box"))).font(.system(size: 36))
                Spacer()
            }.padding()
        }
    }
}
