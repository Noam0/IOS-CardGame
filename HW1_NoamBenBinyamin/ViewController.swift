import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Game_LBL_title: UILabel!
    @IBOutlet weak var game_lbl_score_left: UILabel!
    @IBOutlet weak var game_label_score_right: UILabel!
    @IBOutlet weak var Game_img_right: UIImageView!
    @IBOutlet weak var Game_img_left: UIImageView!
    @IBOutlet weak var gameSwitch: UISwitch! // Add this IBOutlet for the switch

    var gameManager = GameManager()
    var timer: Timer?

    override func viewDidLoad() {
            super.viewDidLoad()
            
        
            setupShadow(for: Game_img_left)
            setupShadow(for: Game_img_right)
            drawInitialCards()
            gameSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            
            // Start the timer if the switch is already on
            if gameSwitch.isOn {
                startTimer()
            }
        }

    func setupShadow(for imageView: UIImageView) {
           imageView.layer.shadowColor = UIColor.black.cgColor
           imageView.layer.shadowOpacity = 0.8
           imageView.layer.shadowOffset = CGSize(width: 5, height: 5)
           imageView.layer.shadowRadius = 10
           imageView.layer.masksToBounds = false
       }
    
    
    func drawInitialCards() {
        if let cards = gameManager.drawCards() {
            updateUI(leftCardName: cards.leftCard, rightCardName: cards.rightCard)
        }
    }

    func updateUI(leftCardName: String, rightCardName: String) {
        Game_img_left.image = UIImage(named: leftCardName)
        Game_img_right.image = UIImage(named: rightCardName)
        
        Game_img_left.accessibilityIdentifier = leftCardName
        Game_img_right.accessibilityIdentifier = rightCardName

        let scores = gameManager.updateScores(leftCardName: leftCardName, rightCardName: rightCardName)
        game_lbl_score_left.text =  "\(scores.scoreLeft)"
        game_label_score_right.text = "\(scores.scoreRight)"
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateCards), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            startTimer()
        } else {
            stopTimer()
        }
    }

    @objc func updateCards() {
        if let cards = gameManager.drawCards() {
            updateUI(leftCardName: cards.leftCard, rightCardName: cards.rightCard)
        } else {
            stopTimer()
            // Optionally, you can display a message to the user that the game is over
        }
    }
}
