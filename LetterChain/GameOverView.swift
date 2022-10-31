//
//  GameOverView.swift
//  LetterChain
//
//  Created by Christophe on 30/10/2022.
//

import SwiftUI

struct GameOverView: View {

    @Environment(\.verticalSizeClass) var sizeClass

    @Binding var session: GameLogic

    @State var gameOver = false

    var body: some View {

        VStack {
            Spacer()
            VStack {
                if gameOver {
                    Text("Game Over")
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .modifier(CustomText())
                        .font(.system(size: 48))
                }
            }.animation(.default, value: gameOver)
            Spacer()
            VStack {
                if gameOver {
                    Text(session.instruction)
                        .transition(.opacity)
                        .multilineTextAlignment(.center)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .modifier(CustomText())
                        .font(.system(size: 24))
                }
            }.animation(.default.delay(1), value: gameOver)
            Spacer()
            if sizeClass == .compact {
                // || LANDSCAPE ||
                HStack {
                    if gameOver {
                        scoreTracker
                        Spacer()
                        highScore()
                    }
                }.animation(.default.delay(2), value: gameOver).frame(maxWidth: 500)
            } else {
                // || PORTRAIT ||
                VStack(alignment: .center, spacing: 40.0) {
                    if gameOver {
                        scoreTracker
                        highScore()
                    }
                }.animation(.default.delay(2), value: gameOver)
            }
            // || END OF DIFFERENCES ||
            Spacer()
            VStack {
                if gameOver {
                    Button("Restart", action: {session.startGame()})
                        .transition(.opacity)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(RoundedRectangle(cornerRadius: 40).foregroundColor(Color("Box")))
                        .modifier(CustomText())
                        .font(.system(size: 36))
                }
            }.animation(.default.speed(0.5).delay(3), value: gameOver)

            Spacer()

        }.animation(.default, value: gameOver)
        .onAppear {DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {gameOver=true}}
        .onDisappear {gameOver=false}
    }

    var scoreTracker: some View {
        VStack {
            Text("Score")
                .modifier(CustomText())
                .font(.system(size: 32))
            Text(String(session.playerScore))
                .modifier(CustomText())
                .font(.system(size: 48))
                .frame(maxWidth: 200)
        }.transition(.move(edge: .leading).combined(with: .opacity))
    }

    @ViewBuilder func highScore() -> some View {
        if session.playerScore > highScoreSave {
            VStack {
                Text("Congratulations! \n You got a new High Score!")
                    .multilineTextAlignment(.center)
                    .modifier(CustomText())
                    .font(.system(size: 32))
            }.transition(.scale.combined(with: .opacity))
        } else {
            VStack {
                Text("High Score")
                    .modifier(CustomText())
                    .font(.system(size: 32))
                Text(String(session.highScore))
                    .modifier(CustomText())
                    .font(.system(size: 48))
                    .frame(maxWidth: 200)

            }.transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }
}
