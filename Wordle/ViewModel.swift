//
//  ViewModel.swift
//  Wordle
//
//  Created by Jorge Sergio Islas Ramos on 02/01/24.
//

import Foundation
import UIKit

enum BannerType {
    case error(String)
    case success
}

final class ViewModel: ObservableObject {
    var numOfRow: Int = 0
    @Published var isShowingChangeWord = false
    @Published var bannerType: BannerType? = nil
    @Published var result: String = "SWIFT"
    @Published var word: [LetterModel] = []
    @Published var gameData: [[LetterModel]] = [
        [.init(""), .init(""), .init(""), .init(""), .init(""),],
        [.init(""), .init(""), .init(""), .init(""), .init(""),],
        [.init(""), .init(""), .init(""), .init(""), .init(""),],
        [.init(""), .init(""), .init(""), .init(""), .init(""),],
        [.init(""), .init(""), .init(""), .init(""), .init(""),],
        [.init(""), .init(""), .init(""), .init(""), .init(""),],
    ]
    
    func addNewLetter(letterModel: LetterModel) {
        bannerType = nil
        
        if letterModel.name == "🚀" {
            tapOnSend()
            return
        }
        if letterModel.name == "🗑️" {
            tapOnRemove()
            return
        }
        if word.count < 5 {
            let letter = LetterModel(letterModel.name)
            word.append(letter)
            gameData[numOfRow][word.count-1] = letter
        }
    }
    
    private func tapOnSend() {
        print("Tap on send")
        guard word.count == 5 else {
            print("Add more letters")
            bannerType = .error("Word needs to have 5 characters.")
            return
        }
        
        let finalStringWord = word.map { $0.name }.joined()
        
        if wordIsReal(word: finalStringWord) {
            print("Correct word")
            
            for (index, _) in word.enumerated() {
                let currentCharacter = word[index].name
                var status: Status
                
                if result.contains(where: { String($0) == currentCharacter}) {
                    status = .appear
                    print("\(currentCharacter) .appear")
                    
                    if currentCharacter == String(result[result.index(result.startIndex, offsetBy: index)]) {
                        status = .match
                        print("\(currentCharacter) .match")
                    }
                } else {
                    status = .dontAppear
                    print("\(currentCharacter) .dontAppear")
                }
                
                //Update GameView
                var updateGameBoardCell = gameData[numOfRow][index]
                updateGameBoardCell.status = status
                gameData[numOfRow][index] = updateGameBoardCell
                
                //Update KeyboardView
                let indexToUpdate = keyboardData.firstIndex(where: { $0.name == word[index].name})
                var keyboardKey = keyboardData[indexToUpdate!]
                if keyboardKey.status != .match {
                    keyboardKey.status = status
                    keyboardData[indexToUpdate!] = keyboardKey
                }
            }
            
            let isUserWinner = gameData[numOfRow].reduce(0) { partialResult, letterModel in
                if letterModel.status == .match {
                    return partialResult + 1
                }
                return 0
            }
            
            if isUserWinner == 5 {
                bannerType = .success
                
            } else {
                //Clean word and move to the new row
                word = []
                numOfRow += 1
            }
            
        } else {
            print("Incorrect word")
            bannerType = .error("Not a real word, try another.")
        }
    }
    
    func hasError(index: Int) -> Bool {
        guard let bannerType = bannerType else {
            return false
        }
        
        switch bannerType {
        case .error(_):
            return index == numOfRow
        case .success:
            return false
        }
    }
    
    private func tapOnRemove() {
        guard word.count > 0 else {
            return
        }
        gameData[numOfRow][word.count-1] = .init("")
        word.removeLast()
    }
    
    func wordIsReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
}
