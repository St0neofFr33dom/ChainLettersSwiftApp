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
    var title: String {
        if sizeClass == .compact {
            return "Chain \u{1F517} Letters"
        } else {
            return "Chain \n \u{1F517} \n Letters"
        }
    }

    var body: some View {

            VStack {
                Spacer()
                    Text("Welcome To").modifier(CustomText()).font(.system(size: 36))
                    Text(title)
                        .font(.system(size: 72))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .modifier(CustomText())
                Spacer()
                Text("High Score: " + String(session.highScore)).modifier(CustomText()).font(.system(size: 36))
                Spacer()
                Button("Start Game") {session.startGame()}
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .modifier(CustomText())
                    .background(RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(Color("Box")))
                    .font(.system(size: 36))
                Spacer()
            }.padding()
        }
}
