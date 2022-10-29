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
        gameLogic.submitInput("ovEn")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssert(gameLogic.previousWords.contains("Oven"))
        XCTAssertEqual(gameLogic.isPlaying, true)
    }
    
    func testTeaInput() throws {
        gameLogic.startGame()
        gameLogic.computerWord = "Best"
        gameLogic.submitInput("Tea")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssert(gameLogic.previousWords.contains("Tea"))
        XCTAssertEqual(gameLogic.isPlaying, true)
    }
    
    func testInvalidWord() throws{
        gameLogic.startGame()
        gameLogic.computerWord = "World"
        gameLogic.submitInput("Doog")
        XCTAssertEqual(gameLogic.playerScore, 0)
        XCTAssertEqual(gameLogic.instruction,"The word inputted cannot be found in our dictionary")
        XCTAssertEqual(gameLogic.isPlaying, false)
    }
    
    func testRepeatedWord() throws{
        gameLogic.startGame()
        gameLogic.computerWord = "Tins"
        gameLogic.submitInput("Seal")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssert(gameLogic.previousWords.contains("Seal"))
        XCTAssertEqual(gameLogic.isPlaying, true)
        gameLogic.computerWord = "Loss"
        gameLogic.submitInput("Seal")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssertEqual(gameLogic.instruction,"The word has already been used")
        XCTAssertEqual(gameLogic.isPlaying, false)
    }


}
