//
//  WordValidator.swift
//  LetterChain
//
//  Created by Christophe on 28/10/2022.
//

import Foundation

struct WordValidator {

    let allWords: Set<String>
    init() {
        let path = Bundle.main.path(forResource: "allWords", ofType: "txt")
        do {
            let text = try String(contentsOfFile: path!)
            allWords = Set(text.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)})
            return

        } catch _ {
            print("error")
        }
        allWords = []
    }

    func validateInput(_ userInput: String) -> Bool {
        let word = userInput.lowercased()
        return allWords.contains(word)
    }

}
