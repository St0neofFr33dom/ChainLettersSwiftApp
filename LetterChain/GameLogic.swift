//
//  GameLogic.swift
//  LetterChain
//
//  Created by Christophe on 28/10/2022.
//

import Foundation




struct GameLogic{
   let wordsSelection: [String:Set<String>]
    init() {
        var wordSet: Set<String> = []
        let path = Bundle.main.path(forResource: "computerWords", ofType: "txt")
        do {
            let text = try String(contentsOfFile: path!)
            wordSet = Set(text.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)})
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
        
        highScore = highScoreSave
    }
    
    var playerScore: Int = 0
    var computerWord: String = ""
    var playerWord: String = ""
    var startingLetter: String = "T"
    
    var highScore: Int

    var previousWords: Set<String> = []

    var instruction: String = "Press the button below to begin"
    
    var isPlaying: Bool = false
    
    mutating func getRandomWord() {
      let selection = wordsSelection.randomElement()?.value
      computerWord = selection?.randomElement() ?? "Default"
      startingLetter = String(computerWord.uppercased()[computerWord.index(before: computerWord.endIndex)])
        instruction = "Type in a word that begins with the letter \n" + String(startingLetter)
      return
    }

    mutating func updateHighScore(){
        userDefaults.set(playerScore, forKey: "highScore")
        highScore = playerScore
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
      let newWords = wordsSelection[String(lastLetter)]
      computerWord = newWords?.randomElement() ?? "Default"
      startingLetter = String(computerWord.uppercased()[computerWord.index(before: computerWord.endIndex)])
        instruction = "Type in a word that begins with the letter \n" + startingLetter
      return
    }

    mutating func recordWord() {
      previousWords.insert(playerWord)
      return
    }
    
    mutating func incrementScore() {
      return playerScore += 1
    }
    
    mutating func newRound() {
        incrementScore()
        recordWord()
        getNewWord()
        playerWord = ""
        instruction = "Type in a word that begins with the letter \n" + String(startingLetter)
        return
    }
    
    mutating func gameOver(_ condition:String){
        switch(condition){
            case "invalid":
                instruction = "The word inputted cannot be found in our dictionary"
            case "repeated":
                instruction = "The word has already been used"
            case "wrongLetter":
                instruction = "This word does not begin with the last letter of the previous word"
            default:
                print("Invalid call to Game Over")
        }
        
    }

    mutating func resetGame() {
      playerScore = 0
      previousWords.removeAll()
      computerWord = ""
        playerWord = ""
      return
    }

    mutating func validateInput() -> Bool{
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
