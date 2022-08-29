//
//  ViewController.swift
//  hangman
//
//  Created by Hassan Sohail Dar on 29/8/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    var attempts: UILabel!
    var guessed: UILabel!
    var hint: UILabel!
    var correctlyGuessedAlphabetsLabel: UILabel!
    var outcome: UILabel!
    var comment: UILabel!
    var hangmanImage: UIImage!
    var correctlyGuessedAlphabetsArray = [String]() {
        didSet {
            correctlyGuessedAlphabetsLabel.text = correctlyGuessedAlphabetsArray.joined()
        }
    }
    var viewableAlphabetsArray = [String]()
    var giveUp: UIButton!
    var showHint: UIButton!
    var startAgain: UIButton!
    
    var selectedWord = ""
    var allWords =  [String]()
    var allHints = [String]()
    
    override func loadView() {
        super.loadView()
        //complete loading words and hints
        performSelector(inBackground: #selector(loadWordsAndHintsInArray), with: nil)
        viewSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func loadWordsAndHintsInArray() {
        print("did come here")
        if let wordsFile = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsString = try? String(contentsOf: wordsFile) {
                var wordsAndHint = wordsString.components(separatedBy: "\n")
                
                for (index, line) in wordsAndHint.enumerated() {
                    var parts = line.description.components(separatedBy: ":")
                    //now we save each word in a dictionary with their respective hint and word
                    allWords.append(parts[0])
                    allHints.append(parts[1].trimmingCharacters(in: .whitespacesAndNewlines))
                }
                print("did come here2")

                print(allWords)
                print(allHints)

            }
            else {
                print("didnt find string")
            }
        } else {
            print("didnt find file")
        }
    }
    
    func viewSetup() {
        view = UIView()
        view.backgroundColor = .white
        
        let guessAndHintView = UIView()
        correctlyGuessedAlphabetsLabel = UILabel()
        correctlyGuessedAlphabetsLabel.translatesAutoresizingMaskIntoConstraints = false
        correctlyGuessedAlphabetsLabel.numberOfLines = 1
        correctlyGuessedAlphabetsLabel.text
        
        
        
        
        
    }
    
    
    
}

