struct GameLogic {

  let wordsSelection: [Character:Set<String>] = ["A":["Apple","Abbot","Alumni"],"B":["Box","Bravo","Balloon","Blitz"],"C":["Clarity","Chat","Clay","Clip"],"D":["Doorknob","Data","Dark"],"E":["Eleven","Echo","Entry","Evening"],"F":["Falling","Foxtrot","Forum"],"G":["Glib","Golf","Grow"],"H":["Hack","Hotel","Haze","Hertz"],"I":["Intent","Indigo","Idiom"],"J":["Jazz","Janitor","Jacuzzi"],"K":["Know","Kilo","Kiss"],"L":["Lima","Lemon","Lord"],"M":["Mess","Mile","Mantra"],"N":["November","Null","Nap"],"O":["Off","Order","Olive"],"P":["Paparazzi","Pasta","Parsnip"],"Q":["Queen","Quest","Quartz"],"R":["Risotto","Random","Rules"],"S":["Send","Saw","Silly","Shiv"],"T":["Tarmac","Tango","Tired"],"U":["Understand","Uniform","Ulcer"],"V":["Vacuum","Victor","Venison"],"W":["Whiskey","Wonder","Wool"],"X":["X-Ray","Xylophone"],"Y":["Yacht","Yellow","Yak"],"Z":["Zulu","Zebra","Zoo"]]
  
  var playerScore: Int = 0
  var computerWord: String = ""
  var playerWord: String = ""
  var startingLetter: Character = "T"

  var previousWords: Set<String> = []

  
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


var session = GameLogic()

print("Welcome to the word game. You will be presented with a word, you will then need to type in a word that begins with the last letter of the presented word.") 
print("If successful, your score will increase and you will be presented with another word that begins with the last letter of the word you inputted.")
print("Words have to be at least 3 characters long, and they have to be unique. If you repeat a word it will be game over.")
gameLoop: while true{

  if session.computerWord == ""{
    session.getRandomWord()
  }

  print("The word is \(session.computerWord), please enter a word beginning with the letter \(session.startingLetter)")

  var isValidated = false
  
  while isValidated == false{
  session.getInput()
  isValidated = session.validateInput()
  }
  
  session.capitaliseWord()
  
  let firstLetter = session.playerWord[session.playerWord.startIndex]
  print("Your word is \(session.playerWord), it starts with the letter \(firstLetter)")
  
  if firstLetter == session.startingLetter && session.previousWords.contains(session.playerWord) == false{
    print("Well done!")
    session.incrementScore()
    session.recordWord()
    session.getNewWord()
  } else {
    print("Game over, your final score is \(session.playerScore)")
    print("Would you like to play again? Type Yes or press enter to confirm")
    let input = readLine() ?? ""
    let confirm = ["Y","Yes","y","yes",""]
    if confirm.contains(input) {
      session.resetGame()
      continue
    } else {
      print("Thank you for playing")
      break
    }
  }
}