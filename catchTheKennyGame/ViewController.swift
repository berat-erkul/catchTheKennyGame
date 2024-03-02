//
//  ViewController.swift
//  catchTheKennyGame
//
//  Created by Berat Erkul on 2.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // Views
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var kennyImage: UIImageView!
    
    // Variables
    var score = 0
    var timer = Timer()
    var counter = 15
    var highestScore = 0
    
    //--------------------------------------- Methods ---------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get highest score from UserDefaults
        if let savedScore = UserDefaults.standard.object(forKey: "score") as? Int {
            highestScore = savedScore
        }
        
        highScoreLabel.text = "Highest score: \(highestScore)"
        
        //TapGestureRecognizer
        kennyImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedKenny))
        kennyImage.addGestureRecognizer(gestureRecognizer)
        
        // Timer --------------------------------------------------------------------------------
        timerLabel.text = "Time: \(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self , selector: #selector(timerFunction), userInfo: nil , repeats: true)
        
        highestScoreControl(score: score) // Call highest score control function
    }
    
    //---------------------------------------------------------
        
    func randomIntX() -> Int {                      //functions to create random integers for x and y (for kenny's position)
        return Int.random(in: 9...311)
    }
        
    func randomIntY() -> Int {
        return Int.random(in: 143...566)
    }

    //---------------------------------------------------------
           
    @objc func timerFunction() {                     //timer function to declare remaining time
        timerLabel.text = "Time: \(counter)"
        counter -= 1
        
        if counter == 0 {
            timer.invalidate()
            timerLabel.text = "Time's Over"
            showGameOverAlert()
        }
    }
    
    //---------------------------------------------------------
    
    @objc func clickedKenny() {                       // when player catch the Kenny
        if counter > 0 {
            kennyImage.frame = CGRect(x: randomIntX(), y: randomIntY(), width: 73, height: 135)
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
    }

    //---------------------------------------------------------
    
    func restartGame() {                               // I create this function to all variables reset
        
        highestScoreControl(score: score)
        counter = 15
        score = 0
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "Time: \(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self , selector: #selector(timerFunction), userInfo: nil , repeats: true)
        kennyImage.frame = CGRect(x: randomIntX(), y: randomIntY(), width: 73, height: 135)
    }
    
    //---------------------------------------------------------
    
    func showGameOverAlert() {                         // "Time's Up" alert, ok and replay buttons
        
        let alert = UIAlertController(title: "Times's up!", message: "Your score: \(score)", preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (_) in
            self.highestScoreControl(score: self.score)
        }
        
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (_) in
            self.restartGame()
        }
        
        alert.addAction(okButton)
        alert.addAction(replayButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------
    
    func highestScoreControl(score: Int) {              // Will we save the score the highest score?
        
        if score > highestScore {
            highestScore = score  //new high
            UserDefaults.standard.set(highestScore, forKey: "score")
            highScoreLabel.text = "Highest score: \(highestScore)"
        }
    }


}

