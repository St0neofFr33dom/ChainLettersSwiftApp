//
//  GameLogic.swift
//  LetterChain
//
//  Created by Christophe on 28/10/2022.
//

import Foundation

struct GameLogic{
    enum GameOverReason {
        case invalid
        case repeated
        case wrongLetter
    }
    
    enum GameState {
        case title
        case playing
        case gameOver
    }
    
    
    var highScore: Int
    
   let wordsSelection: [String:Set<String>]
    
    let validator: WordValidator
    
    var gameState: GameState
    
    init(hiScore: Int) {
        var wordSet: Set<String> = []
        let path = Bundle.main.path(forResource: "computerWords", ofType: "txt")
        do {
            let text = try String(contentsOfFile: path!)
            wordSet = Set(text.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()})
        }
        catch(_){
            print("error")
        }

        wordsSelection = wordSet.reduce(into: [String: Set<String>]()) { partialResult, word in
            if word.count >= 3, let key = word.first?.uppercased() {
                var s = partialResult[key] ?? []
                s.insert(word)
                partialResult[key] = s
            }
        }
        
        highScore = hiScore
        validator = WordValidator()
        gameState = .title
    }
    
    var playerScore: Int = 0
    var computerWord: String = ""
    var playerWord: String = ""
    var startingLetter: String {
        String(computerWord[computerWord.index(before: computerWord.endIndex)])
    }
    
    var previousWords: Set<String> = []
    
    struct Entry: Equatable{
        let id = UUID()
        
        let word: String
        init(input:String){
            word = input
        }
    }
    
    var chainedWords: [Entry] = []
    var instruction: String = "Press the button below to begin"
    
    
    
    
    mutating func startGame(){
        
        resetGame()
        getNewWord()
        gameState = .playing

    }
    
    mutating func submitInput(_ userInput:String) -> Void{
        playerWord = userInput
        guard validateInput() == true else {
            return
        }
        
        guard validator.validateInput(playerWord) == true else{
            gameOver( .invalid)
            return
        }
        
        let firstLetter = String(playerWord[playerWord.startIndex])
        
        if firstLetter != startingLetter{
            gameOver(  .wrongLetter)

        } else if previousWords.contains(playerWord) == true{
            gameOver( .repeated)
        } else {
            newRound()
        }
    }

    mutating func gameOver(  _ condition: GameOverReason){
        if playerScore > highScore{
            highScore = playerScore
        }
        switch(condition){
        case .invalid:
            instruction = "Your word could not be found in our dictionary"
        case .repeated:
            instruction = "Your word has already been used"
        case .wrongLetter:
            instruction = "Your word did not chain off of the previous word"
        }
        gameState = .gameOver
    }
    

    private mutating func getNewWord() {
        let newWords: Set<String>?
        if playerWord == ""{
            newWords = wordsSelection.randomElement()?.value
        }
        else{
            let lastLetter = playerWord.uppercased()[playerWord.index(before: playerWord.endIndex)]
            newWords = wordsSelection[String(lastLetter)]
        }
        while true {
            let selection = newWords?.randomElement() ?? "Default"
            if previousWords.contains(selection) == false{
                computerWord = selection
                instruction = "Type in a word that begins with the letter \n"
                recordWord(word: computerWord)
                break
            }
        }
    }

    private mutating func recordWord(word:String) {
      previousWords.insert(word)
        chainedWords.append(Entry(input:word))
        if chainedWords.count > 5{
            chainedWords.removeFirst()
        }
    }
    
    private mutating func incrementScore() {
        playerScore += 1
    }
    
    private mutating func newRound() {
        incrementScore()
        recordWord(word:playerWord)
        getNewWord()
        playerWord = ""
        instruction = "Type in a word that begins with the letter \n"
    }
  
    private mutating func resetGame() {
        playerScore = 0
        previousWords.removeAll()
        chainedWords.removeAll()
        computerWord = ""
        playerWord = ""
    }

    private mutating func validateInput() -> Bool{
      guard playerWord.allSatisfy({$0.isWholeNumber == false}) == true else {
      instruction = "Please don't type numbers"
      return false
    }
    guard playerWord.allSatisfy({$0 != " "}) == true else {
      instruction = "Please omit any spaces, and type only one word"
      return false
    }
    guard playerWord.count >= 3 else{
      instruction = "Please input a word that is at least 3 letters long"
      return false
    }
      return true
    }
    
}
