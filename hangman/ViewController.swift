//
//  ViewController.swift
//  hangman
//
//  Created by Hassan Sohail Dar on 29/8/2022.
//

import UIKit

class ViewController: UIViewController {
    let letters = [ "A", "B", "C", "D", "E", "F","G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U" , "V", "W", "X", "Y", "Z"]
    var alphabetButtons = [UIButton]()
    var gameTitle: UILabel!
    var attempts: UILabel! //0/7
    var guessed: UILabel!
    var hintLabel: UILabel!
    var correctlyGuessedAlphabetsLabel: UILabel!
    var wordToGuess = ""
    var outcome: UILabel!
    var comment: UILabel!
    var hangmanImage: UIImage!
    var hangmanImageView: UIImageView!
    var giveUp: UIButton!
    var showHint: UIButton!
    var startAgain: UIButton!
    
    //actual computations and processing words
    var selectedWord = ""
    var selectedHint = ""
    var numberOfAttempts = 0 {
        didSet {
            attempts.text = "\(numberOfAttempts)/7"
            hangmanImageView.image = UIImage(named: "img\(numberOfAttempts).png")
        }
    }
    var allWords =  [String]()
    var allHints = [String]()
    var correctlyGuessedAlphabetsArray = [Character]() {
        didSet {
            correctlyGuessedAlphabetsLabel.text = String(correctlyGuessedAlphabetsArray)
        }
    }
//    var viewableAlphabetsArray = [String]()
   
    
  
    
    override func loadView() {
        super.loadView()
        //complete loading words and hints
//        performSelector(inBackground: #selector(loadWordsAndHintsInArray), with: nil)
        viewSetup()

        loadWordsAndHintsInArray()
        
        StartTheGame()
        
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func loadWordsAndHintsInArray() {
        if let wordsFile = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsString = try? String(contentsOf: wordsFile) {
                let wordsAndHint = wordsString.components(separatedBy: "\n")
                
                for (_, line) in wordsAndHint.enumerated() {
                    let parts = line.description.components(separatedBy: ":")
                    //now we save each word in a dictionary with their respective hint and word
                    allWords.append(parts[0])
                    allHints.append(parts[1].trimmingCharacters(in: .whitespacesAndNewlines))
                }
                
                
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
        
        
        //correctly guessed alphabets
        correctlyGuessedAlphabetsLabel = UILabel()
        correctlyGuessedAlphabetsLabel.translatesAutoresizingMaskIntoConstraints = false
        correctlyGuessedAlphabetsLabel.numberOfLines = 1
        correctlyGuessedAlphabetsLabel.font = UIFont.systemFont(ofSize: 44)
        correctlyGuessedAlphabetsLabel.text = "_ _ _ _ _ _ _ _ _ _"
        correctlyGuessedAlphabetsLabel.textAlignment = .center
        
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.numberOfLines = 3
        hintLabel.font = UIFont.systemFont(ofSize: 24)
        hintLabel.textAlignment = .left
        hintLabel.text = "HINT TEXT if it works if it works if it works if it works if it works check if it works if it works if it works"
        
      
        
        //comment and outcome and tries on the left
        //image on the right
        let imgAndOtherLabels = UIView()
        imgAndOtherLabels.translatesAutoresizingMaskIntoConstraints = false
        imgAndOtherLabels.backgroundColor = .systemGray2
        
        attempts = UILabel()
        attempts.translatesAutoresizingMaskIntoConstraints = false
        attempts.textAlignment = .left
        attempts.backgroundColor = .black
        attempts.textColor = .white
        attempts.text = "0/7"
        attempts.font = UIFont.systemFont(ofSize: 44)
        
        comment = UILabel()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.textAlignment = .left
        comment.backgroundColor = .systemGray
        comment.text = "CORRECT !!!/ TRY AGAIN !!!"
        comment.font = UIFont.systemFont(ofSize: 24)
        
        outcome = UILabel()
        outcome.translatesAutoresizingMaskIntoConstraints = false
        outcome.textAlignment = .left
        outcome.backgroundColor = .systemGray
        outcome.text = "OUTCOME"
        outcome.font = UIFont.systemFont(ofSize: 24)
        
        hangmanImage = UIImage()
        hangmanImage = UIImage(named: "img0.png")
        
        hangmanImageView = UIImageView(image: hangmanImage)
        hangmanImageView.translatesAutoresizingMaskIntoConstraints = false
        //        hangmanImageView.sizeToFit()
        
   
        
        let alphabetView = UIView()
        alphabetView.translatesAutoresizingMaskIntoConstraints = false
        alphabetView.backgroundColor = .systemGray2
        
        view.addSubview(guessAndHintView)
        guessAndHintView.addSubview(correctlyGuessedAlphabetsLabel)
        guessAndHintView.addSubview(hintLabel)

        view.addSubview(imgAndOtherLabels)
        imgAndOtherLabels.addSubview(attempts)
        imgAndOtherLabels.addSubview(comment)
        imgAndOtherLabels.addSubview(outcome)
        imgAndOtherLabels.addSubview(hangmanImageView)

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
                    
                    // and also to our alphabetButtons array
                    alphabetButtons.append(alphabetButton)
                    alphabetCounter += 1

                }
            }
        
        giveUp = UIButton()
        giveUp.translatesAutoresizingMaskIntoConstraints = false
        giveUp.backgroundColor = .systemGray2
        giveUp.layer.borderColor = UIColor.gray.cgColor
        giveUp.layer.borderWidth = 1
        giveUp.addTarget(self, action: #selector(giveUpAction), for: .touchUpInside)
        giveUp.setTitle("GIVE UP", for: .normal)
        
        showHint = UIButton()
        showHint.translatesAutoresizingMaskIntoConstraints = false
        showHint.backgroundColor = .systemGray2
        showHint.layer.borderColor = UIColor.gray.cgColor
        showHint.layer.borderWidth = 1
        showHint.addTarget(self, action: #selector(showHintAction), for: .touchUpInside)
        showHint.setTitle("SHOW HINT", for: .normal)
        
        
        startAgain = UIButton()
        startAgain.translatesAutoresizingMaskIntoConstraints = false
        startAgain.backgroundColor = .systemGray2
        startAgain.layer.borderColor = UIColor.gray.cgColor
        startAgain.layer.borderWidth = 1
        startAgain.addTarget(self, action: #selector(startAgainAction), for: .touchUpInside)

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
            correctlyGuessedAlphabetsLabel.trailingAnchor.constraint(equalTo: guessAndHintView.trailingAnchor),
            
            correctlyGuessedAlphabetsLabel.widthAnchor.constraint(equalTo: guessAndHintView.widthAnchor, constant: -10),
            correctlyGuessedAlphabetsLabel.heightAnchor.constraint(equalToConstant: 60),
            
            hintLabel.topAnchor.constraint(equalTo: correctlyGuessedAlphabetsLabel.bottomAnchor, constant: 10),
            hintLabel.leadingAnchor.constraint(equalTo: guessAndHintView.leadingAnchor, constant: 10),
            hintLabel.trailingAnchor.constraint(equalTo: guessAndHintView.trailingAnchor),
            
            hintLabel.widthAnchor.constraint(equalTo: guessAndHintView.widthAnchor, constant: -10),
            hintLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            hintLabel.bottomAnchor.constraint(greaterThanOrEqualTo: guessAndHintView.bottomAnchor, constant: 10),
            
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
//
            alphabetView.topAnchor.constraint(equalTo: imgAndOtherLabels.bottomAnchor, constant: 10),
//            alphabetView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            alphabetView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            alphabetView.widthAnchor.constraint(equalToConstant: 350),
            alphabetView.heightAnchor.constraint(equalToConstant: 200),

            giveUp.topAnchor.constraint(equalTo: alphabetView.bottomAnchor, constant: 10),
            giveUp.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            giveUp.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.33, constant: -10),

            showHint.topAnchor.constraint(equalTo: alphabetView.bottomAnchor, constant: 10),
            showHint.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.33),
            showHint.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),

            startAgain.topAnchor.constraint(equalTo: alphabetView.bottomAnchor, constant: 10),
            startAgain.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            startAgain.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.33, constant: -10),

            
        ])
        
        
    }
    
    @objc func selectWord() {
        //select the random word and populate the array.
        let randomWordIndex = Int.random(in: 0..<allWords.count)
        selectedWord = allWords[randomWordIndex]
        selectedHint = allHints[randomWordIndex]
        for _ in 0..<selectedWord.count  {
            correctlyGuessedAlphabetsArray.append("-")

        }
//        print("correctlyGuessedAlphabetsArray = \(correctlyGuessedAlphabetsArray)")
        correctlyGuessedAlphabetsLabel.text = String(correctlyGuessedAlphabetsArray)
        
    }
    
    @objc func updateView() {
        //should check if the word is correct. If yes, show the alphabets after updating correctlyGuessed
        
        
        
        //update attempts, comments and outcome if necessary
        
        
        //update the image if necessary
        
        //update the alphabet it necessary
        
        
        
        
        
    }
    
    func showAllButtons() {
        for alphabetButton in alphabetButtons {
            alphabetButton.isHidden = false
        }
    }
    
    @objc func alphabetTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        if (selectedWord.contains(Character(buttonTitle))) {
            
            comment.backgroundColor = .systemMint
            comment.text = "Good Guess"
            //do as such that the label for guessed is properly showing
            for (index, item) in selectedWord.enumerated() {
                if item  == Character(buttonTitle) {
                    correctlyGuessedAlphabetsArray[index] = Character(buttonTitle)
                }
//                print(correctlyGuessedAlphabetsArray)
            }
            //checking if the word is now guessed
            if selectedWord == String(correctlyGuessedAlphabetsArray) {
                outcome.textColor = .systemCyan
                outcome.text = "YOU WON ! Congrats"
                //UIALert here
                let ac = UIAlertController(title: "You Won!", message: "Congrats! Good Effort", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] args in
                    self?.StartTheGame()
                    
                })
                
                present(ac, animated: true)
                return
            }
            
            
            sender.isHidden = true
            return
        }
        //if the attempt is wrong and if attempts are finished call give up and reset
        
        numberOfAttempts += 1
//        print(numberOfAttempts)
        if numberOfAttempts == 7 {
            outcome.text = "YOU LOST!!"
            
            let ac = UIAlertController(title: "You Lost!", message: "Sorry, try again. Good Attempt though", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] args in
                self?.StartTheGame()
            })
            present(ac, animated: true)
            return
        }
        else {
            //do the things if it is wrong.
            comment.text = "TRY AGAIN"
            comment.backgroundColor = .systemRed
            sender.isHidden = true

        }
    }
    
    @objc func giveUpAction(_ sender: UIButton! = nil) {
        //will show the word. change the image and then 2 second delay restart the game and call StartSetup
        outcome.text = "You gave up! Better luck next time."
        let ac = UIAlertController(title: "Player defeated", message: "Sorry, try again. Good Attempt though", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] args in
            self?.StartTheGame()
        })
        present(ac, animated: true)
        return

    }
    
    func StartTheGame() {
        numberOfAttempts = 0
        comment.text = ""
        comment.backgroundColor = .systemGray2
        outcome.text = ""
        hintLabel.text = ""
        correctlyGuessedAlphabetsArray = []
        
        
        selectWord()
        showAllButtons()

    }

    @objc func showHintAction(_ sender: UIButton) {
        //will show the word. change the image and then 2 second delay restart the game and call StartSetup
        
        hintLabel.text = "Hint: " + selectedHint
        return
    }

    @objc func startAgainAction(_ sender: UIButton) {
        //will show the word. change the image and then 2 second delay restart the game and call StartSetup
        StartTheGame()
    }

    
    
}

