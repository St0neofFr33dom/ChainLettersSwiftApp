//  ContentView.swift
//  LetterChain
//
//  Created by Christophe on 27/10/2022.
//

import SwiftUI

struct customText : ViewModifier {
    func body(content: Content) -> some View {
            content
                .foregroundColor(Color("Text"))
        }
}

struct gameLogic{
    let wordsSelection: [Character:Set<String>] = ["A":["Apple","Abbot","Alumni"],"B":["Box","Bravo","Balloon","Blitz"],"C":["Clarity","Chat","Clay","Clip"],"D":["Doorknob","Data","Dark"],"E":["Eleven","Echo","Entry","Evening"],"F":["Falling","Foxtrot","Forum"],"G":["Glib","Golf","Grow"],"H":["Hack","Hotel","Haze","Hertz"],"I":["Intent","Indigo","Idiom"],"J":["Jazz","Janitor","Jacuzzi"],"K":["Know","Kilo","Kiss"],"L":["Lima","Lemon","Lord"],"M":["Mess","Mile","Mantra"],"N":["November","Null","Nap"],"O":["Off","Order","Olive"],"P":["Paparazzi","Pasta","Parsnip"],"Q":["Queen","Quest","Quartz"],"R":["Risotto","Random","Rules"],"S":["Send","Saw","Silly","Shiv"],"T":["Tarmac","Tango","Tired"],"U":["Understand","Uniform","Ulcer"],"V":["Vacuum","Victor","Venison"],"W":["Whiskey","Wonder","Wool"],"X":["X-Ray","Xylophone"],"Y":["Yacht","Yellow","Yak"],"Z":["Zulu","Zebra","Zoo"]]
    
    var playerScore: Int = 0
    var computerWord: String = ""
    var playerWord: String = ""
    var startingLetter: Character = "T"

    var previousWords: Set<String> = []

    var instruction: String = "Welcome to Chain Letters \n Press the button below to begin"
    
    mutating func getRandomWord() {
      let selection = wordsSelection.randomElement()?.value
      computerWord = selection?.randomElement() ?? "Default"
      startingLetter = computerWord.uppercased()[computerWord.index(before: computerWord.endIndex)]
      return
    }

    mutating func getInput() {
      return playerWord = readLine() ?? ""
    }

    mutating func capitaliseWord() {
      //Prevents player repeating words with different casing
      var lowercaseWord = playerWord.lowercased()
      lowercaseWord.removeFirst()
      let firstLetter = playerWord.uppercased()[playerWord.startIndex]
      lowercaseWord.insert(firstLetter,at:lowercaseWord.startIndex)
      return playerWord = lowercaseWord

    }

    mutating func getNewWord() {
      let lastLetter = playerWord.uppercased()[playerWord.index(before: playerWord.endIndex)]
      let newWords = wordsSelection[lastLetter]
      computerWord = newWords?.randomElement() ?? "Default"
      startingLetter = computerWord.uppercased()[computerWord.index(before: computerWord.endIndex)]
      return
    }

    mutating func recordWord() {
      previousWords.insert(playerWord)
      return
    }
    
    mutating func incrementScore() {
      return playerScore += 1
    }

    mutating func resetGame() {
      playerScore = 0
      previousWords.removeAll()
      computerWord = ""
      return
    }

    func validateInput() -> Bool{
      guard playerWord.allSatisfy({$0.isWholeNumber == false}) == true else {
      print("Please don't type numbers")
      return false
    }
    guard playerWord.allSatisfy({$0 != " "}) == true else {
      print("Please omit any spaces, and type only one word")
      return false
    }
    guard playerWord.count >= 3 else{
      print("Please input a word that is at least 3 letters long")
      return false
    }
      return true
    }
    
}

func playGame(_ state: inout gameLogic) -> Void{
    
    
gameLoop: while true{
    
    state.computerWord = ""
    
    if state.computerWord == ""{
        state.getRandomWord()
    }
    
    state.instruction = "Type in a word that begins with the letter \n" + String(state.startingLetter)
    
    
    
    break
    
}
}

struct ContentView: View {
    
    @State var session = gameLogic()
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color("Top"), Color("Bottom")]), startPoint: /*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Spacer()
                Text("Chain Letters")
                    .font(.headline)
                    .fontWeight(.bold)
                    .modifier(customText())
                
                Spacer()
                
                HStack{
                    VStack{
                        Text("Time Left")
                            .modifier(customText())
                        Text(String(12))
                            .modifier(customText())
                    }
                    Spacer()
                    VStack{
                        Text("Score")
                            .modifier(customText())
                        Text(String(session.playerScore))
                            .modifier(customText())
                    }
                }
                
                Spacer()
                
                
                        
                VStack {
                    Spacer()
                    Text(session.computerWord)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .modifier(customText())
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Box")/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Text(session.instruction)
                        .multilineTextAlignment(.center)
                        .lineSpacing(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    
                        
                    Spacer()
                    Text(session.playerWord)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .modifier(customText())
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Box")/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                
                
                
                
                Spacer()
                Button("Start Game"){playGame(&session)} .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).modifier(customText()).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Box")/*@END_MENU_TOKEN@*/)
                
                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
