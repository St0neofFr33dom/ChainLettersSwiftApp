//  ContentView.swift
//  LetterChain
//
//  Created by Christophe on 27/10/2022.
//

import SwiftUI

struct CustomText : ViewModifier {
    func body(content: Content) -> some View {
            content
                .foregroundColor(Color("Text"))
        }
}

struct ContentView: View {
    

    @State var userInput: String = ""
    
    @State var session: GameLogic
    
    @FocusState var inputInFocus: Bool
    @State var gameOver = false
    
    func updateHighScore(){
        if session.highScore > highScoreSave{
            userDefaults.set(session.highScore, forKey: "highScore")
        }
    }
    
    init(session: GameLogic = GameLogic(hiScore: highScoreSave)) {
        self.session = session
    }

    var body: some View {
        
        ZStack{
            
            if session.gameState == .title{
                ZStack{
                    
                    LinearGradient(gradient: Gradient(colors: [Color("Top"), Color("Bottom")]), startPoint: /*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    VStack {
                        Spacer()
                        Text("Welcome To").modifier(CustomText())
                        Text("Chain Letters")
                            .font(.headline)
                            .fontWeight(.bold)
                            .modifier(CustomText())
                        Spacer()
                        Text("Hi-Score: " + String(session.highScore)).modifier(CustomText())
                        //                    Spacer()
                        //                    Text(session.instruction).multilineTextAlignment(.center).modifier(CustomText())
                        Spacer()
                        Button("Start Game"){session.startGame()} .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).modifier(CustomText()).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Box")/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }.padding()
                }
            }
            
            
            
            if session.gameState == .playing {
                ZStack{
                    Rectangle().foregroundColor(Color.blue)
                    
                    
                    VStack {
                        VStack{
                            Text("Opponent's Word").modifier(CustomText())
                            Text(session.computerWord)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                .modifier(CustomText())
                                .font(.system(size: 36))
                                .animation(.linear(duration: 0.5).delay(1),value:session.computerWord)
                        }.frame(maxWidth:.infinity,maxHeight:200).background(Color("Top"))
                        
                        
                        
                        //                        Spacer()
                        //                        Text(session.instruction).modifier(CustomText())
                        //                            .multilineTextAlignment(.center)
                        //                            .lineSpacing(5)
                        //                        Text(session.startingLetter)
                        //                            .modifier(CustomText())
                        //                            .font(.system(size: 64))
                        ScrollViewReader { value in
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(alignment:.center){
                                    ForEach(session.chainedWords, id: \.id){
                                        chain in
                                        Text(chain.word)
                                            .font(.system(size: 48))
                                            .lineLimit(1)
                                            .id(chain.id)
                                        Text("\u{1F517}")
                                            .font(.system(size: 48))
                                    }.onChange(of: session.chainedWords){_ in
                                        withAnimation {
                                            value.scrollTo("lastLetter", anchor: .trailing)}
                                        if session.isComputerTurn {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                session.takeComputerTurn()
                                                inputInFocus = true
                                            }
                                        }
                                    }
                                    
                                    Text(session.startingLetter)
                                        .id("lastLetter")
                                        .font(.system(size: 48)).foregroundColor(Color("HighlightText"))
                                }
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            }.disabled(true)
                            
                            
                        }.frame(maxWidth:.infinity,maxHeight:200).background(Color("Bottom"))
                        
                        VStack{
                            TextField("\(session.startingLetter)...", text: $userInput)
                                .textInputAutocapitalization(.characters)
                                .disabled(session.isComputerTurn)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                .onSubmit({
                                    session.submitInput(userInput)
                                    userInput = ""
                                    self.inputInFocus = true
                                })
                                .font(.system(size: 48))
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled()
                                .focused($inputInFocus)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                        self.inputInFocus = true
                                    }
                                }
                            Button("SUBMIT", action: {session.submitInput(userInput)
                                userInput = ""
                                self.inputInFocus = true})
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .modifier(CustomText())
                            .font(.system(size: 28))
                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.black))
                        }.frame(maxWidth:.infinity,maxHeight:.infinity).background(Color("Top"))
                    }
                }.onDisappear{updateHighScore()}
            }
            
            if session.gameState == .gameOver{
                ZStack{
                    Rectangle().foregroundColor(Color.blue).ignoresSafeArea()
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
                                                .modifier(CustomText())
                                                .font(.system(size: 32))
                                        }
                                    }.animation(.default.delay(1),value:gameOver)
                                        Spacer()
                                        VStack(alignment: .center, spacing: 40.0){
                                            if gameOver == true{
                                                Text("Your score was: " + String(session.playerScore)).modifier(CustomText())
                                                    .font(.system(size: 32))
                                                    .transition(.move(edge: .leading).combined(with: .opacity))
                                                if session.playerScore > highScoreSave{
                                                    Text("Congratulations! \n You got a new High Score!")
                                                        .multilineTextAlignment(.center)
                                                        .modifier(CustomText())
                                                        .font(.system(size: 32))
                                                        .transition(.scale)
                                                } else{
                                                    Text("High Score: " + String(session.highScore)).modifier(CustomText())
                                                        .font(.system(size: 32))
                                                        .transition(.move(edge: .trailing).combined(with: .opacity))
                                                }
                                            }
                                        }.animation(.default.delay(2), value:gameOver)
                                        Spacer()
                                VStack{
                                    if gameOver == true{
                                        Button("Restart", action: {session.startGame()})
                                            .transition(.opacity)
                                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.black))
                                            .modifier(CustomText())
                                            .font(.system(size: 36))
                                    }
                                }.animation(.default.speed(0.5).delay(3), value: gameOver)
                                        Spacer()
                            }.animation(.default, value: gameOver)
                    
                }.onAppear{DispatchQueue.main.asyncAfter(deadline: .now() + 0.75){gameOver=true}}.onDisappear{gameOver=false}
            }
        }.animation(.default, value: session.gameState)
    }
        }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(session: exampleSession)
    }
    
    static var exampleSession: GameLogic {
        var session = GameLogic(hiScore: 0)
        session.startGame()
//        session.gameState = .gameOver
        return session
    }
}
