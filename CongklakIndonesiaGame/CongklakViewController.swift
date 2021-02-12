//
//  CongklakViewController.swift
//  CongklakIndonesiaGame
//
//  Created by Elfa Andika on 11/02/21.
//

import UIKit

protocol CongklakViewControllerDelegate {
    func getWinnerName(description: String)
}

class CongklakViewController: UIViewController {


    @IBOutlet weak var player1Image: UIImageView!
    @IBOutlet weak var player2Image: UIImageView!
    @IBOutlet weak var holdMarblePlayer1: UILabel!
    @IBOutlet weak var holdMarblePlayer2: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var footer: UIView!
    
    private let congklakPresenter = CongklakPresenter()
    var congklakViewControllerDelegate: CongklakViewControllerDelegate?
    var tempCurSession = PlayerSession.Player1
    var descriptionLabel = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        congklakPresenter.setViewDelegate(congklakPresenterDelegate: self)
        setupLayout()
        congklakPresenter.firstLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: false, completion: nil)
    }
    
    func setViewDelegate(congklakViewControllerDelegate: CongklakViewControllerDelegate) {
        self.congklakViewControllerDelegate = congklakViewControllerDelegate
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupLayout() {
        player1Image.image = UIImage(named: K.imagePlayer1)
        player2Image.image = UIImage(named: K.imagePlayer2)
        header.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        header.layer.opacity = 0.85
        footer.layer.opacity = 0.85
        holdMarblePlayer2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    // MARK:- Button State Manipulation
    func disableButtonStatus() {
        for tag in 1...16 {
            if let button = self.view.viewWithTag(tag) as? UIButton {
                button.isEnabled = false
                button.isHighlighted = true
                button.layer.borderColor = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
            }
        }
    }
    
    func resetToOriginalState() {

        for tag in 1...16 {
            if let button = self.view.viewWithTag(tag) as? UIButton {
                button.isEnabled = true
                button.layer.borderColor = #colorLiteral(red: 0.9944948554, green: 0.9108413458, blue: 0.8078600168, alpha: 1)
            }
        }
        let base1 = self.view.viewWithTag(8) as? UIButton
        let base2 = self.view.viewWithTag(16) as? UIButton
        base1?.isEnabled = false
        base2?.isEnabled = false
        
        
    }
    
    // MARK:- Update Button State for Next Session
    func nextSessionButtonStatus(session: (PlayerSession,Bool)) {
        var tempSession = PlayerSession.Player1
        
        if session.1 {
            tempSession = session.0
        }
        else {
            var temp: PlayerSession {
                if session.0 == .Player1 {
                    return .Player2
                }
                else {return .Player1}
            }
            tempSession = temp
        }
        
        for tag in 1...16 {
            if let button = self.view.viewWithTag(tag) as? UIButton {
                button.isEnabled = false
                button.isHighlighted = true
                button.layer.borderColor = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
            }
        }
        switch tempSession {
        case .Player1:
            for tag in 1...7 {
                if let button = self.view.viewWithTag(tag) as? UIButton {
                    button.isEnabled = true
                    button.layer.borderColor = #colorLiteral(red: 0.9944948554, green: 0.9108413458, blue: 0.8078600168, alpha: 1)
                }
            }
        case .Player2:
            for tag in 9...15 {
                if let button = self.view.viewWithTag(tag) as? UIButton {
                    button.isEnabled = true
                    button.layer.borderColor = #colorLiteral(red: 0.9944948554, green: 0.9108413458, blue: 0.8078600168, alpha: 1)
                }
            }
        }
    }
    
    // MARK:- Response Tap Button
    @IBAction func slotPressed(_ sender: UIButton) {
        sender.alpha = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            sender.alpha = 1.0
            congklakPresenter.playerButtonTap(buttonIndex: sender.tag-1) { (session) in
                self.nextSessionButtonStatus(session: session)
            }
        }
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        congklakPresenter.resetGame()
        congklakPresenter.firstLoad()
        resetToOriginalState()
        
    }
    
    @IBAction func exitPressed(_ sender: UIButton) {
        let vc = self
        vc.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.gameResultSegue {

            let destinationVC = segue.destination as! GameResult
            destinationVC.text = descriptionLabel
        }
    }
    
}

// MARK:- Update UI Data
extension CongklakViewController: CongklakPresenterDelegate{
    func getWinner(description: String) {
        descriptionLabel = description
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.performSegue(withIdentifier: K.gameResultSegue, sender: self)
        }
        
    }
    
    func getSession(session: PlayerSession) {
        self.tempCurSession = session
    }
    

    func firstUILoad(slot: [Int]) {
        let toString: [String] = slot.map{String(Int($0))}
        
        for tag in 1...16 {
            if let button = self.view.viewWithTag(tag) as? UIButton {
                button.setTitle(toString[tag-1], for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.9944948554, green: 0.9108413458, blue: 0.8078600168, alpha: 1)
            }
        }
    }
    
    func updateUI(slot: [Int], pointer: Int?, marble: Int?) {
        let toString: [String] = slot.map{String(Int($0))}
        disableButtonStatus()

        switch tempCurSession {
        case .Player1:
            holdMarblePlayer1.text = String("Hold marble: \(marble!)")
        case .Player2:
            holdMarblePlayer2.text = String("Hold marble: \(marble!)")
        }
        
        if let index = pointer {
            let button = self.view.viewWithTag(index+1) as? UIButton
            DispatchQueue.main.async {
                button?.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
        }
        for tag in 1...16 {
            if let titleButton = self.view.viewWithTag(tag) as? UIButton {
                DispatchQueue.main.async {
                    titleButton.setTitle(toString[tag-1], for: .normal)
                }
            }
        }
    }
}
