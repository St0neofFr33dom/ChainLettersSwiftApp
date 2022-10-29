//
//  GameLogicTest.swift
//  LetterChainTests
//
//  Created by Christophe on 29/10/2022.
//

import XCTest

final class GameLogicTest: XCTestCase {

    var gameLogic: GameLogic!
    
    override func setUpWithError() throws {

        gameLogic = GameLogic(hiScore: 0)
    }

    override func tearDownWithError() throws {

        gameLogic = nil
    }

    func testStartGame() throws {
        gameLogic.startGame()
        XCTAssertEqual(gameLogic.previousWords.count, 0,"Words are not reset")
        XCTAssertGreaterThan(gameLogic.computerWord.count, 2)
        XCTAssertEqual(gameLogic.isPlaying,true,"Game has not been initialised")
    }
    
    func testValidInput() throws {
        gameLogic.startGame()
        gameLogic.computerWord = "Hello"
        gameLogic.startingLetter = "O"
        gameLogic.submitInput("ovEn")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssert(gameLogic.previousWords.contains("Oven"))
        XCTAssertEqual(gameLogic.isPlaying, true)
    }
    
    func testTeaInput() throws {
        gameLogic.startGame()
        gameLogic.computerWord = "Best"
        gameLogic.startingLetter = "T"
        gameLogic.submitInput("Tea")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssert(gameLogic.previousWords.contains("Tea"))
        XCTAssertEqual(gameLogic.isPlaying, true)
    }


}
