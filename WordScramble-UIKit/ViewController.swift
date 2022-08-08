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
    
    private func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
    }
    
    private func submit(answer: String) {
        usedWords.append(answer)
        tableView.reloadData()
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

