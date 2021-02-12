//
//  GameResult.swift
//  CongklakIndonesiaGame
//
//  Created by Elfa Andika on 12/02/21.
//

import UIKit
import Lottie

class GameResult: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    var animationView: AnimationView?
    var text: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.layer.cornerRadius = 15
        baseView.layer.opacity = 0.85
        textLabel.text = text
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupAnimation()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupAnimation() {
        animationView = .init(name: K.winLottie)
        animationView?.frame = CGRect(x:50 , y: 50, width: 300, height: 300)
        animationView?.backgroundColor = #colorLiteral(red: 0.9966183305, green: 0.9112530947, blue: 0.8029767275, alpha: 1)
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.play()
        view.addSubview(animationView!)
        view.sendSubviewToBack(animationView!)
        }
}
