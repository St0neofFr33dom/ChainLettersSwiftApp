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
        XCTAssertEqual(gameLogic.previousWords.count, 1,"Words are not reset")
        XCTAssertGreaterThan(gameLogic.computerWord.count, 2)
        XCTAssertEqual(gameLogic.gameState,.playing,"Game has not been initialised")
    }
    
    func testValidInput() throws {
        gameLogic.startGame()
        gameLogic.computerWord = "HELLO"
        gameLogic.submitInput("OVEN")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssert(gameLogic.previousWords.contains("OVEN"))
        XCTAssertEqual(gameLogic.gameState,.playing)
    }
    
    func testTeaInput() throws {
        gameLogic.startGame()
        gameLogic.computerWord = "BEST"
        gameLogic.submitInput("TEA")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssert(gameLogic.previousWords.contains("TEA"))
        XCTAssertEqual(gameLogic.gameState,.playing)
    }
    
    func testInvalidWord() throws{
        gameLogic.startGame()
        gameLogic.computerWord = "WORLD"
        gameLogic.submitInput("DOOG")
        XCTAssertEqual(gameLogic.playerScore, 0)
        XCTAssertEqual(gameLogic.instruction,"Your word could not be found in our dictionary")
        XCTAssertEqual(gameLogic.gameState,.gameOver)
    }
    
    func testRepeatedWord() throws{
        gameLogic.startGame()
        gameLogic.computerWord = "TINS"
        gameLogic.submitInput("SEAL")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssert(gameLogic.previousWords.contains("SEAL"))
        XCTAssertEqual(gameLogic.gameState,.playing)
        gameLogic.computerWord = "LOSS"
        gameLogic.submitInput("SEAL")
        XCTAssertEqual(gameLogic.playerScore, 1)
        XCTAssertEqual(gameLogic.instruction,"Your word has already been used")
        XCTAssertEqual(gameLogic.gameState,.gameOver)
    }


}
