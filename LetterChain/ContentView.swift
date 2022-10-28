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




func startGame(_ state: inout GameLogic, _ isPlaying: inout Bool) -> Void{
    
    state.resetGame()
    state.getRandomWord()
    isPlaying = true
    
    return

}

func submitInput(_ state: inout GameLogic, _ isPlaying: inout Bool) -> Void{
    guard state.validateInput() == true else {
        return
    }
    state.capitaliseWord()
    let firstLetter = state.playerWord[state.playerWord.startIndex]
    if firstLetter != state.startingLetter{
        state.gameOver("wrongLetter")
        isPlaying = false
    } else if state.previousWords.contains(state.playerWord) == true{
        state.gameOver("repeated")
        isPlaying = false
    } else {
        state.newRound()
    }
}

struct ContentView: View {
    
    @State var isPlaying: Bool = false
    
    @State var session = GameLogic()
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color("Top"), Color("Bottom")]), startPoint: /*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            if isPlaying == false{
                VStack {
                    Spacer()
                    Text("Welcome To").modifier(CustomText())
                    Text("Chain Letters")
                        .font(.headline)
                        .fontWeight(.bold)
                        .modifier(CustomText())
                    Spacer()
                    Text(session.instruction).modifier(CustomText())
                    Spacer()
                    Button("Start Game"){startGame(&session,&isPlaying)} .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).modifier(CustomText()).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Box")/*@END_MENU_TOKEN@*/)
                    Spacer()
                }.padding()
            }
            
            
                
            if isPlaying {
                      
                VStack{
                    Spacer()
                    HStack(alignment: .top){
                        VStack{
                            Text("Time Left")
                                .modifier(CustomText())
                            Text(String(12))
                                .modifier(CustomText())
                        }
                        Spacer()
                        VStack{
                            Text("Score")
                                .modifier(CustomText())
                            Text(String(session.playerScore))
                                .modifier(CustomText())
                        }
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        Text("Computer's Word").modifier(CustomText())
                        Text(session.computerWord)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .modifier(CustomText())
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Box")/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Text(session.instruction).modifier(CustomText())
                            .multilineTextAlignment(.center)
                            .lineSpacing(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                        
                        
                        Spacer()
                        
                        
                        HStack{
                            TextField("Input", text: $session.playerWord).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).onSubmit({submitInput(&session,&isPlaying)})
                            Button("Submit", action: {submitInput(&session,&isPlaying)})
                        }
                        
                        
                        Spacer()
                    }
                }
            }
                
            }
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
