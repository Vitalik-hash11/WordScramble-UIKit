//
//  ViewController.swift
//  WordScramble-UIKit
//
//  Created by newbie on 08.08.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    private var allWords = [String]()
    private var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddAlert))
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }

        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    @objc private func showAddAlert() {
        let ac = UIAlertController(title: "Enter you answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            let userAnswer = ac?.textFields?[0].text ?? ""
            self?.submit(answer: userAnswer)
        }
        
        ac.addAction(submitAction)
        navigationController?.present(ac, animated: true)
    }
    
    @objc private func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
    }
    
    private func submit(answer: String) {
        let lowercased = answer.lowercased()
        
        if isPossible(word: lowercased) {
            if isOrigin(word: lowercased) {
                if isReal(word: lowercased) {
                    usedWords.append(lowercased)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(errorTitle: "Given word does not exist", errorMessage: "Use only real words!")
                }
            } else {
                showErrorMessage(errorTitle: "You already used that word", errorMessage: "Try to be more original")
            }
        } else {
            showErrorMessage(errorTitle: "Word is not possible", errorMessage: "You cannot spell that word from \(title!)")
        }
    }
    
    private func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word {
            if let possition = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: possition)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isOrigin(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isReal(word: String) -> Bool {
        if word.count < 3 || word == title! {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    private func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }


}

