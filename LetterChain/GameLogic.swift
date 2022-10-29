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
    var instruction: String = "Press the button below to begin"
    
    
    mutating func startGame(){
        
        resetGame()
        getRandomWord()
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
        
        playerWord = playerWord.capitalized
        
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
            instruction = "The word inputted cannot be found in our dictionary"
        case .repeated:
            instruction = "The word has already been used"
        case .wrongLetter:
            instruction = "This word does not begin with the last letter of the previous word"
        }
        gameState = .gameOver
    }
    
    private mutating func getRandomWord() {
      let selection = wordsSelection.randomElement()?.value
        computerWord = selection?.randomElement() ?? "Default"
        instruction = "Type in a word that begins with the letter \n"
      return
    }


    private mutating func getNewWord() {
      let lastLetter = playerWord.uppercased()[playerWord.index(before: playerWord.endIndex)]
      let newWords = wordsSelection[String(lastLetter)]
      computerWord = newWords?.randomElement() ?? "Default"
        instruction = "Type in a word that begins with the letter \n"
      return
    }

    private mutating func recordWord() {
      previousWords.insert(playerWord)
      return
    }
    
    private mutating func incrementScore() {
      return playerScore += 1
    }
    
    private mutating func newRound() {
        incrementScore()
        recordWord()
        getNewWord()
        playerWord = ""
        instruction = "Type in a word that begins with the letter \n"
        return
    }
  
    private mutating func resetGame() {
      playerScore = 0
      previousWords.removeAll()
      computerWord = ""
        playerWord = ""
      return
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
