//
//  ViewController.swift
//  hangman
//
//  Created by Hassan Sohail Dar on 29/8/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var gameTitle: UILabel!
    var attempts: UILabel!
    var guessed: UILabel!
    var hintLabel: UILabel!
    var correctlyGuessedAlphabetsLabel: UILabel!
    var outcome: UILabel!
    var comment: UILabel!
    var hangmanImage: UIImage!
    var hangmanImageView: UIImageView!
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
                let wordsAndHint = wordsString.components(separatedBy: "\n")
                
                for (_, line) in wordsAndHint.enumerated() {
                    let parts = line.description.components(separatedBy: ":")
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
        
        gameTitle = UILabel()
        gameTitle.translatesAutoresizingMaskIntoConstraints = false
        gameTitle.text = " H A N G M A N "
        gameTitle.backgroundColor = .black
        gameTitle.textColor = .white
        gameTitle.textAlignment = .center
        view.addSubview(gameTitle)
        
        //adding subview to main view
        let guessAndHintView = UIView()
        guessAndHintView.translatesAutoresizingMaskIntoConstraints = false
        guessAndHintView.backgroundColor = .systemGray2
        view.addSubview(guessAndHintView)
        
        
        //correctly guessed alphabets
        correctlyGuessedAlphabetsLabel = UILabel()
        correctlyGuessedAlphabetsLabel.translatesAutoresizingMaskIntoConstraints = false
        correctlyGuessedAlphabetsLabel.numberOfLines = 1
        correctlyGuessedAlphabetsLabel.font = UIFont.systemFont(ofSize: 44)
        correctlyGuessedAlphabetsLabel.text = "_ _ _ _ _ _ _ _ _ _"
        correctlyGuessedAlphabetsLabel.textAlignment = .center
        guessAndHintView.addSubview(correctlyGuessedAlphabetsLabel)
        
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.numberOfLines = 3
        hintLabel.font = UIFont.systemFont(ofSize: 24)
        hintLabel.textAlignment = .left
        hintLabel.text = "HINT TEXT if it works if it works if it works if it works if it works check if it works if it works if it works"
        
        guessAndHintView.addSubview(hintLabel)

        //comment and outcome and tries on the left
        //image on the right
        let imgAndOtherLabels = UIView()
        imgAndOtherLabels.translatesAutoresizingMaskIntoConstraints = false
        imgAndOtherLabels.backgroundColor = .systemCyan
        view.addSubview(imgAndOtherLabels)
        
        hangmanImage = UIImage()
        hangmanImage = UIImage(named: "img1.png")
        hangmanImageView = UIImageView(image: hangmanImage)
        imgAndOtherLabels.addSubview(hangmanImageView)
        
        

        
        //Setting up constraints for everything
        NSLayoutConstraint.activate([
            
            gameTitle.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            gameTitle.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            gameTitle.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 100),

//            gameTitle.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            gameTitle.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8, constant: -100),
            gameTitle.heightAnchor.constraint(equalToConstant: 60),
        //guessAndHintView First
            guessAndHintView.topAnchor.constraint(equalTo: gameTitle.bottomAnchor, constant: 20),
            guessAndHintView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            guessAndHintView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            guessAndHintView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1.0),
            guessAndHintView.heightAnchor.constraint(equalToConstant: 175),

//            //correctlyGuessedLabel and hintLabel inside guessAndHintView
            correctlyGuessedAlphabetsLabel.topAnchor.constraint(equalTo: guessAndHintView.topAnchor, constant: 10),
            correctlyGuessedAlphabetsLabel.leadingAnchor.constraint(equalTo: guessAndHintView.leadingAnchor, constant: 10),
            correctlyGuessedAlphabetsLabel.trailingAnchor.constraint(equalTo: guessAndHintView.trailingAnchor, constant: 10),

            correctlyGuessedAlphabetsLabel.widthAnchor.constraint(equalTo: guessAndHintView.widthAnchor, constant: -10),
            correctlyGuessedAlphabetsLabel.heightAnchor.constraint(equalToConstant: 60),

            hintLabel.topAnchor.constraint(equalTo: correctlyGuessedAlphabetsLabel.bottomAnchor, constant: 10),
            hintLabel.leadingAnchor.constraint(equalTo: guessAndHintView.leadingAnchor, constant: 10),
            hintLabel.trailingAnchor.constraint(equalTo: guessAndHintView.trailingAnchor, constant: 10),

            hintLabel.widthAnchor.constraint(equalTo: guessAndHintView.widthAnchor, constant: -10),
            hintLabel.heightAnchor.constraint(equalToConstant: 100),
            hintLabel.bottomAnchor.constraint(greaterThanOrEqualTo: guessAndHintView.bottomAnchor, constant: 10),
//
//            //now setting img and otherlabels
            imgAndOtherLabels.topAnchor.constraint(equalTo: guessAndHintView.bottomAnchor, constant: 10),
            imgAndOtherLabels.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
//            imgAndOtherLabels.heightAnchor.constraint(equalToConstant: 150),
            imgAndOtherLabels.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8)
//

            
            

            
            


        ])


    }
    
    
    
}

