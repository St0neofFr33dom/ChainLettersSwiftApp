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
    
    func updateHighScore(){
        if session.highScore > highScoreSave{
            userDefaults.set(session.highScore, forKey: "highScore")
        }
    }
    
    init(session: GameLogic = GameLogic(hiScore: highScoreSave)) {
        self.session = session
    }

    var body: some View {
        
        
            
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
                                .animation(.easeOut(duration: 1),value:session.computerWord)
                        }.frame(maxWidth:.infinity,maxHeight:.infinity).background(Color("Top"))
                        
                        
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
                                            .font(.title)
                                            .lineLimit(1)
                                            .id(chain.id)
                                        Text("\u{1F517}")
                                            .font(.title)
                                    }.onChange(of: session.chainedWords){_ in
                                        withAnimation(Animation.easeIn(duration: 5)){
                                            value.scrollTo("lastLetter", anchor: .trailing)}}
                                    Text(session.startingLetter)
                                            .id("lastLetter")
                                            .font(.title).foregroundColor(Color("HighlightText"))
                                    }
                                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            }.disabled(true)
                            
                       
                            }.frame(maxWidth:.infinity,maxHeight:200).background(Color("Bottom"))
                            
                        VStack{
                            TextField("\(session.startingLetter)...", text: $userInput)
                                .textInputAutocapitalization(.characters)
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
                            Button("Submit", action: {session.submitInput(userInput)
                                userInput = ""
                                self.inputInFocus = true})
                            .modifier(CustomText())
                        }.frame(maxWidth:.infinity,maxHeight:.infinity).background(Color("Top"))
                    }
                }.onDisappear{updateHighScore()}
            }
        
        if session.gameState == .gameOver{
            ZStack{
                Rectangle().foregroundColor(Color.blue)
                VStack{
                    Spacer()
                    Text("Game Over")
                        .modifier(CustomText())
                        .font(.system(size: 48))
                    Spacer()
                    Text(session.instruction)
                        .multilineTextAlignment(.center)
                        .modifier(CustomText())
                        .font(.system(size: 32))
                    Spacer()
                    VStack(alignment: .center, spacing: 40.0){
                        Text("Your score was: " + String(session.playerScore)).modifier(CustomText())
                            .font(.system(size: 24))
                        if session.playerScore > highScoreSave{
                            Text("Congratulations! \n You got a new High Score!")
                                .multilineTextAlignment(.center)
                                .modifier(CustomText())
                                .font(.system(size: 24))
                        } else{
                            Text("High Score: " + String(session.highScore)).modifier(CustomText())
                                .font(.system(size: 24))
                        }
                    }
                    Spacer()
                    Button("Restart", action: {session.startGame()})
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.black))
                        .modifier(CustomText())
                        .font(.system(size: 36))
                    Spacer()
                }
            }
        }
        
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
