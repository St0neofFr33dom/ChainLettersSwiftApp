//  ContentView.swift
//  LetterChain
//
//  Created by Christophe on 27/10/2022.
//

import SwiftUI

struct CustomText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("Text"))
    }
}

struct ContentView: View {
    @State var session: GameLogic

    init(session: GameLogic = GameLogic(hiScore: highScoreSave)) {
        self.session = session
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Top"), Color("Bottom")]),
                           startPoint: /*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/,
                           endPoint: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                .edgesIgnoringSafeArea(.all)
            if session.gameState == .title {
                TitleView(session: $session)
            }
            if session.gameState == .playing {
                PlayView(session: $session)
            }
            if session.gameState == .gameOver {
                GameOverView(session: $session)
            }
        }.animation(.easeOut(duration: 2), value: session.gameState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(session: exampleSession)
    }
    static var exampleSession: GameLogic {
        var session = GameLogic(hiScore: 0)
        session.startGame()
        return session
    }
}
