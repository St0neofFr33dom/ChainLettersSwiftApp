//
//  PlayView.swift
//  LetterChain
//
//  Created by Christophe on 30/10/2022.
//

import SwiftUI


struct PlayView: View {
    
    @Environment(\.verticalSizeClass) var sizeClass
    
    @Binding var session: GameLogic
    
    @State var userInput: String = ""
    
    var placeHolder: String{
        if session.isComputerTurn == true{
            return ""
        } else {
            return "\(session.startingLetter)..."
        }
    }
    
    func updateHighScore(){
        if session.highScore > highScoreSave{
            userDefaults.set(session.highScore, forKey: "highScore")
        }
    }
    
    @FocusState var inputInFocus: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("Top"), Color("Bottom")]), startPoint: /*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/).ignoresSafeArea()
            
            VStack {
                
                VStack{
                    if sizeClass == .regular {
                        // || PORTRAIT ||
                        Text("Opponent's Word").modifier(CustomText())
                        Text(session.computerWord)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .modifier(CustomText())
                            .font(.system(size: 36))
                            .animation(.linear(duration: 0.5).delay(1),value:session.computerWord)
                            .frame(maxWidth:.infinity,maxHeight:200)
                        
                        ScrollViewReader { value in
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(alignment:.center){
                                    ForEach(session.chainedWords, id: \.id){
                                        chain in
                                        Text(chain.word)
                                            .font(.system(size: 48))
                                            .modifier(CustomText())
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
                                        .font(.system(size: 48)).foregroundColor(Color("Bottom"))
                                }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            }.disabled(true)
                            
                            
                        }.frame(maxWidth:.infinity,maxHeight:200).background(Color("Box"))
                        
                        VStack{
                            
                            TextField(placeHolder, text: $userInput)
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
                            .font(.system(size: 36))
                            .background(RoundedRectangle(cornerRadius: 40).foregroundColor(Color("Box")))
                            
                        }.frame(maxWidth:.infinity,maxHeight:.infinity)
                    }
                    else{
                        //|| LANDSCAPE ||
                            Text("Opponent's Word:    \(session.computerWord)")
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                .modifier(CustomText())
                                .font(.system(size: 24))
                                .animation(.linear(duration: 0.5).delay(1),value:session.computerWord)
                                .frame(maxWidth:.infinity,maxHeight:50)
                        ScrollViewReader { value in
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(alignment:.center){
                                    ForEach(session.chainedWords, id: \.id){
                                        chain in
                                        Text(chain.word)
                                            .font(.system(size: 36))
                                            .modifier(CustomText())
                                            .lineLimit(1)
                                            .id(chain.id)
                                        Text("\u{1F517}")
                                            .font(.system(size: 36))
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
                                        .font(.system(size: 36)).foregroundColor(Color("Bottom"))
                                }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            }.disabled(true)
                            
                            
                        }.frame(maxWidth:.infinity,maxHeight:100).background(Color("Box"))
                        
                        VStack{
                            
                            TextField(placeHolder, text: $userInput)
                                .textInputAutocapitalization(.characters)
                                .disabled(session.isComputerTurn)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                .onSubmit({
                                    session.submitInput(userInput)
                                    userInput = ""
                                    self.inputInFocus = true
                                })
                                .font(.system(size: 36))
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
                            .font(.system(size: 24))
                            .background(RoundedRectangle(cornerRadius: 40).foregroundColor(Color("Box")))
                            
                        }.frame(maxWidth:.infinity,maxHeight:200)
                    }
                    // || END OF DIFFERENCES ||
                }
            }
        }.onDisappear{updateHighScore()}
    }
}
