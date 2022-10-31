//
//  PlayView.swift
//  LetterChain
//
//  Created by Christophe on 30/10/2022.
//

import SwiftUI

struct PlayView: View {

    @Environment(\.verticalSizeClass) var sizeClass

    @Binding var session: GameLogic

    @State var userInput: String = ""

    var placeHolder: String {
        if session.isComputerTurn == true {
            return ""
        } else {
            return "\(session.startingLetter)..."
        }
    }

    var buttonDisabled: Bool {
        return userInput.count < 3
    }

    func updateHighScore() {
        if session.highScore > highScoreSave {
            userDefaults.set(session.highScore, forKey: "highScore")
        }
    }

    @FocusState var inputInFocus: Bool

    var chain: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(session.chainedWords, id: \.id) { chain in
                        Text(chain.word)
                            .font(.system(size: 48))
                            .modifier(CustomText())
                            .lineLimit(1)
                            .id(chain.id)
                        Text("\u{1F517}")
                            .font(.system(size: 48))
                    }.onChange(of: session.chainedWords) {_ in
                        withAnimation {
                            value.scrollTo("lastLetter", anchor: .trailing)}
                        if session.isComputerTurn {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                session.takeComputerTurn()
                                inputInFocus = true
                            }
                        }
                    }

                    Text(session.startingLetter)
                        .id("lastLetter")
                        .font(.system(size: 48)).foregroundColor(Color("Bottom"))
                }.padding(.vertical, 32.0).padding(.horizontal)
            }.disabled(true)
        }
    }

    func textField(size: CGFloat, alignment: TextAlignment) -> some View {
        TextField(placeHolder, text: $userInput)
            .textInputAutocapitalization(.characters)
            .onChange(of: userInput, perform: { newValue in
                if newValue != "" && session.isComputerTurn {
                    userInput = ""
                }

            })
            .onSubmit({
                guard !buttonDisabled else {return}
                session.submitInput(userInput)
                userInput = ""
                self.inputInFocus = true
            })
            .font(.system(size: size))
            .multilineTextAlignment(alignment)
            .autocorrectionDisabled()
            .focused($inputInFocus)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.inputInFocus = true
                }
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }

    func submitButton(size: CGFloat) -> some View {
        Button("SUBMIT", action: {session.submitInput(userInput)
                userInput = ""
                self.inputInFocus = true})
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .modifier(CustomText())
            .font(.system(size: size))
            .background(RoundedRectangle(cornerRadius: 40).foregroundColor(Color("Box")))
            .disabled(buttonDisabled)
    }

    var portrait: some View {
        VStack {
            VStack {
                Text("Opponent's Word").modifier(CustomText())
                Text(session.computerWord)
                    .modifier(CustomText())
                    .font(.system(size: 36))
                    .animation(.linear(duration: 0.5).delay(1), value: session.computerWord)
            }.frame(maxWidth: .infinity, minHeight: 50)
            chain.frame(maxWidth: .infinity).background(Color("Box"))

            VStack {

                textField(size: 48, alignment: .center)
                submitButton(size: 36)

            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    var landscape: some View {
        VStack {
            chain.frame(maxWidth: .infinity, maxHeight: 100).background(Color("Box"))
            HStack {
                VStack {
                    Text("Opponent's Word").modifier(CustomText())
                    Text(session.computerWord)
                        .modifier(CustomText())
                        .font(.system(size: 36))
                        .animation(.linear(duration: 0.5).delay(1), value: session.computerWord)
                }.frame(maxWidth: .infinity, minHeight: 50)
                HStack {
                    textField(size: 36, alignment: .leading)
                    submitButton(size: 24)

                }.frame(maxWidth: 400, maxHeight: 200)
            }
        }
    }

    var body: some View {
            VStack {
                if sizeClass == .compact {
                    landscape
                } else {
                    portrait
                }
            }.onDisappear {updateHighScore()}
        }
}
