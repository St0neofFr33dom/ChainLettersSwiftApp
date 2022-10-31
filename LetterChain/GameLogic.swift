//
//  GameLogic.swift
//  LetterChain
//
//  Created by Christophe on 28/10/2022.
//

import Foundation

struct GameLogic {
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

    let wordsSelection: [String: Set<String>]

    let validator: WordValidator

    var gameState: GameState

    var isComputerTurn: Bool = false

    init(hiScore: Int) {
        var wordSet: Set<String> = []
        let path = Bundle.main.path(forResource: "computerWords", ofType: "txt")
        do {
            let text = try String(contentsOfFile: path!)
            wordSet = Set(text.components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()})
        } catch _ {
            print("error")
        }

        wordsSelection = wordSet.reduce(into: [String: Set<String>]()) { partialResult, word in
            if word.count >= 3, let key = word.first?.uppercased() {
                var set = partialResult[key] ?? []
                set.insert(word)
                partialResult[key] = set
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
        guard isComputerTurn == false else {
            return String(playerWord[playerWord.index(before: playerWord.endIndex)])
        }
        return String(computerWord[computerWord.index(before: computerWord.endIndex)])
    }

    var previousWords: Set<String> = []

    struct Entry: Equatable {
        let id = UUID()

        let word: String
        init(input: String) {
            word = input
        }
    }

    var chainedWords: [Entry] = []
    var instruction: String = "Press the button below to begin"

    mutating func startGame() {

        resetGame()
        getNewWord()
        recordWord(word: computerWord)
        gameState = .playing

    }

    mutating func submitInput(_ userInput: String) {
        playerWord = userInput.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard validator.validateInput(playerWord) else {
            gameOver( .invalid)
            return
        }

        let firstLetter = String(playerWord[playerWord.startIndex])

        if firstLetter != startingLetter {
            gameOver(  .wrongLetter)

        } else if previousWords.contains(playerWord) {
            gameOver( .repeated)
        } else {
            newRound()
        }
    }

    mutating func gameOver(  _ condition: GameOverReason) {
        if playerScore > highScore {
            highScore = playerScore
        }
        switch condition {
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
        } else {
            let lastLetter = playerWord.uppercased()[playerWord.index(before: playerWord.endIndex)]
            newWords = wordsSelection[String(lastLetter)]
        }

        while true {
            let selection = newWords?.randomElement() ?? "Default"
            if previousWords.contains(selection) == false {
                computerWord = selection
                break
            }
        }
    }

    private mutating func recordWord(word: String) {
        previousWords.insert(word)
        chainedWords.append(Entry(input: word))
    }

    private mutating func incrementScore() {
        playerScore += 1
    }

    private mutating func newRound() {
        incrementScore()
        recordWord(word: playerWord)
        getNewWord()
        isComputerTurn = true
    }

    mutating func takeComputerTurn() {
        recordWord(word: computerWord)
        isComputerTurn = false
        playerWord = ""
    }

    private mutating func resetGame() {
        playerScore = 0
        previousWords.removeAll()
        chainedWords.removeAll()
        computerWord = ""
        playerWord = ""
    }

}
