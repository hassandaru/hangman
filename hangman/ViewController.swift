//
//  ViewController.swift
//  hangman
//
//  Created by Hassan Sohail Dar on 29/8/2022.
//

import UIKit

class ViewController: UIViewController {
    let letters = [ "A", "B", "C", "D", "E", "F","G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U" , "V", "W", "X", "Y", "Z"]
    var letterButtons = [UIButton]()
    var gameTitle: UILabel!
    var attempts: UILabel! //0/7
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
        imgAndOtherLabels.backgroundColor = .systemGray2
        view.addSubview(imgAndOtherLabels)
        
        attempts = UILabel()
        attempts.translatesAutoresizingMaskIntoConstraints = false
        attempts.textAlignment = .left
        attempts.backgroundColor = .black
        attempts.textColor = .white
        attempts.text = "0/7"
        attempts.font = UIFont.systemFont(ofSize: 44)
        imgAndOtherLabels.addSubview(attempts)
        
        comment = UILabel()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.textAlignment = .left
        comment.backgroundColor = .systemGray
        comment.text = "CORRECT !!!/ TRY AGAIN !!!"
        comment.font = UIFont.systemFont(ofSize: 24)
        imgAndOtherLabels.addSubview(comment)
        
        outcome = UILabel()
        outcome.translatesAutoresizingMaskIntoConstraints = false
        outcome.textAlignment = .left
        outcome.backgroundColor = .systemGray
        outcome.text = "OUTCOME"
        outcome.font = UIFont.systemFont(ofSize: 24)
        imgAndOtherLabels.addSubview(outcome)
        
        hangmanImage = UIImage()
        hangmanImage = UIImage(named: "img1.png")
        
        hangmanImageView = UIImageView(image: hangmanImage)
        hangmanImageView.translatesAutoresizingMaskIntoConstraints = false
        //        hangmanImageView.sizeToFit()
        
        imgAndOtherLabels.addSubview(hangmanImageView)
        
        let alphabetView = UIView()
        alphabetView.translatesAutoresizingMaskIntoConstraints = false
        alphabetView.backgroundColor = .systemGray2
        view.addSubview(alphabetView)
        
        let btnWidth = 50
        let btnHeight = 50
        //adding alphabet buttons
        
        //counter to see how many letters printed
        var alphabetCounter = 0
    outerLoop: for row in 0..<4 {
                for col in 0..<7 {
                    if(alphabetCounter == 26) {
                        break outerLoop
                        //means all letters are p
                    }
                    let alphabetButton = UIButton(type: .system)
                    alphabetButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                    alphabetButton.layer.borderColor = UIColor.gray.cgColor
                    alphabetButton.layer.borderWidth = 1
                    alphabetButton.titleLabel?.textColor = .black
                    
                    // give the button some temporary text so we can see it on-screen
                    alphabetButton.setTitle(letters[alphabetCounter], for: .normal)
                    alphabetButton.addTarget(self, action: #selector(alphabetTapped), for: .touchUpInside)
                    
                    
                    // calculate the frame of this button using its column and row
                    let frame = CGRect(x: col * btnWidth , y: row * btnHeight, width: btnWidth, height: btnHeight)
                    alphabetButton.frame = frame
                    
                    // add it to the buttons view
                    alphabetView.addSubview(alphabetButton)
                    
                    // and also to our letterButtons array
                    letterButtons.append(alphabetButton)
                    alphabetCounter += 1

                }
            }
        print(letterButtons.count)
        
        giveUp = UIButton()
        giveUp.translatesAutoresizingMaskIntoConstraints = false
        giveUp.backgroundColor = .systemGray2
        giveUp.layer.borderColor = UIColor.gray.cgColor
        giveUp.layer.borderWidth = 1
        giveUp.setTitle("GIVE UP", for: .normal)
        
        showHint = UIButton()
        showHint.translatesAutoresizingMaskIntoConstraints = false
        showHint.backgroundColor = .systemGray2
        showHint.layer.borderColor = UIColor.gray.cgColor
        showHint.layer.borderWidth = 1
        showHint.setTitle("SHOW HINT", for: .normal)
        
        
        startAgain = UIButton()
        startAgain.translatesAutoresizingMaskIntoConstraints = false
        startAgain.backgroundColor = .systemGray2
        startAgain.layer.borderColor = UIColor.gray.cgColor
        startAgain.layer.borderWidth = 1
        startAgain.setTitle("START AGAIN", for: .normal)
        
        
        view.addSubview(giveUp)
        view.addSubview(showHint)
        view.addSubview(startAgain)
        
        
        //Setting up constraints for everything
        NSLayoutConstraint.activate([
            
            gameTitle.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            //            gameTitle.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            //            gameTitle.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 100),
            gameTitle.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            //            gameTitle.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            gameTitle.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
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
            imgAndOtherLabels.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            //            imgAndOtherLabels.heightAnchor.constraint(equalToConstant: 150),
            imgAndOtherLabels.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.9, constant: -100),
            imgAndOtherLabels.heightAnchor.constraint(equalToConstant: 300),
            //
            //attempts, comments, outcome, img
            attempts.topAnchor.constraint(equalTo: imgAndOtherLabels.topAnchor, constant: 10),
            attempts.leadingAnchor.constraint(equalTo: imgAndOtherLabels.leadingAnchor, constant: 10),
            attempts.widthAnchor.constraint(equalTo: imgAndOtherLabels.widthAnchor, multiplier: 0.5),
            attempts.heightAnchor.constraint(equalToConstant: 60),
            
            comment.topAnchor.constraint(equalTo: attempts.bottomAnchor, constant: 10),
            comment.leadingAnchor.constraint(equalTo: imgAndOtherLabels.leadingAnchor, constant: 10),
            comment.widthAnchor.constraint(equalTo: attempts.widthAnchor),
            comment.heightAnchor.constraint(equalToConstant: 60),
            
            outcome.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: 10),
            outcome.leadingAnchor.constraint(equalTo: imgAndOtherLabels.leadingAnchor, constant: 10),
            outcome.widthAnchor.constraint(equalTo: attempts.widthAnchor),
            outcome.heightAnchor.constraint(equalToConstant: 60),
            //
            hangmanImageView.topAnchor.constraint(equalTo: imgAndOtherLabels.topAnchor, constant: 10),
            hangmanImageView.trailingAnchor.constraint(equalTo: imgAndOtherLabels.trailingAnchor, constant: -10),
            hangmanImageView.widthAnchor.constraint(equalToConstant: 135),
            hangmanImageView.heightAnchor.constraint(equalToConstant: 180),
            
            alphabetView.topAnchor.constraint(equalTo: imgAndOtherLabels.bottomAnchor, constant: 10),
//            alphabetView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            alphabetView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            alphabetView.widthAnchor.constraint(equalToConstant: 350),
            alphabetView.heightAnchor.constraint(equalToConstant: 200),
            
            giveUp.topAnchor.constraint(equalTo: alphabetView.bottomAnchor, constant: 10),
            giveUp.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            giveUp.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.3, constant: -10),
            
            showHint.topAnchor.constraint(equalTo: alphabetView.bottomAnchor, constant: 10),
            showHint.leadingAnchor.constraint(equalTo: giveUp.trailingAnchor),
            showHint.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.3),
            showHint.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            startAgain.topAnchor.constraint(equalTo: alphabetView.bottomAnchor, constant: 10),
            startAgain.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            startAgain.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.3, constant: -10),
            
            
            
            
            
            
        ])
        
        
    }
    
    @objc func alphabetTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        sender.isHidden = true
    }
    
}

