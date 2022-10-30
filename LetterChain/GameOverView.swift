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
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("Top"), Color("Bottom")]), startPoint: /*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/).ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                VStack {
                    if gameOver == true{
                        Text("Game Over")
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .modifier(CustomText())
                            .font(.system(size: 48))
                    }
                }.animation(.default, value: gameOver)
                
                Spacer()
                
                VStack {
                    if gameOver == true{
                        Text(session.instruction)
                            .transition(.opacity)
                            .multilineTextAlignment(.center)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .modifier(CustomText())
                            .font(.system(size: 24))
                    }
                }.animation(.default.delay(1),value:gameOver)
                
                Spacer()
                if sizeClass == .regular{
                    // || PORTRAIT ||
                    VStack(alignment: .center, spacing: 40.0){
                        if gameOver == true{
                            VStack{
                                Text("Score")
                                    .modifier(CustomText())
                                    .font(.system(size: 32))
                                Text(String(session.playerScore))
                                    .modifier(CustomText())
                                    .font(.system(size:48))
                            }.transition(.move(edge: .leading).combined(with: .opacity))
                            if session.playerScore > highScoreSave{
                                Text("Congratulations! \n You got a new High Score!")
                                    .multilineTextAlignment(.center)
                                    .modifier(CustomText())
                                    .font(.system(size: 32))
                                    .transition(.scale.combined(with: .opacity))
                            } else{
                                VStack{
                                    Text("High Score")
                                        .modifier(CustomText())
                                        .font(.system(size: 32))
                                    Text(String(session.highScore))
                                        .modifier(CustomText())
                                        .font(.system(size:48))
                                    
                                }.transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                    }.animation(.default.delay(2), value:gameOver)
                } else {
                    // || LANDSCAPE ||
                    HStack{
                        if gameOver == true{
                            VStack{
                                Text("Score")
                                    .modifier(CustomText())
                                    .font(.system(size: 32))
                                Text(String(session.playerScore))
                                    .modifier(CustomText())
                                    .font(.system(size:48))
                                    .frame(maxWidth: 200)
                            }.transition(.move(edge: .leading).combined(with: .opacity))
                            Spacer()
                            if session.playerScore > highScoreSave{
                                Text("Congratulations! \n You got a new High Score!")
                                    .multilineTextAlignment(.center)
                                    .modifier(CustomText())
                                    .font(.system(size: 32))
                                    .transition(.scale.combined(with: .opacity))
                            } else{
                                VStack{
                                    Text("High Score")
                                        .modifier(CustomText())
                                        .font(.system(size: 32))
                                    Text(String(session.highScore))
                                        .modifier(CustomText())
                                        .font(.system(size:48))
                                        .frame(maxWidth: 200)
                                    
                                }.transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                    }.animation(.default.delay(2), value:gameOver).frame(maxWidth: 500)
                }
                
                // || END OF DIFFERENCES ||
                Spacer()
                
                VStack{
                    if gameOver == true{
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
        }.onAppear{DispatchQueue.main.asyncAfter(deadline: .now() + 0.75){gameOver=true}}.onDisappear{gameOver=false}
    }
}

