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
        
        
            
        if session.isPlaying == false{
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
            
            
                
        if session.isPlaying {
            ZStack{
                Rectangle().foregroundColor(Color.blue)
                //                    Spacer()
                //                    HStack(alignment: .top){
                //                        VStack{
                //                            Text("Time Left")
                //                                .modifier(CustomText())
                //                            Text(String(timeRemaining))
                //                                .modifier(CustomText())
                //                        }
                //                        Spacer()
                //                        VStack{
                //                            Text("Score")
                //                                .modifier(CustomText())
                //                            Text(String(session.playerScore))
                //                                .modifier(CustomText())
                //                        }
                //                    }
                //                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                //
                //                    Spacer()
                    VStack {
                        Spacer()
                        VStack{
                            Text("Opponent's Word").modifier(CustomText())
                            Text(session.computerWord)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                .modifier(CustomText())
                                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Box")/*@END_MENU_TOKEN@*/)
                        }
                        
                        
                                                Spacer()
                                                Text(session.instruction).modifier(CustomText())
                                                    .multilineTextAlignment(.center)
                                                    .lineSpacing(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                                                Text(session.startingLetter)
                                                    .modifier(CustomText())
                                                    .font(.system(size: 64))
                        
                        
                        
                        
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
                        }
                        
                        
                        Spacer()
                    }
                }.onDisappear{updateHighScore()}
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
        return session
    }
}
