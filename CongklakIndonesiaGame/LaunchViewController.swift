//
//  ViewController.swift
//  CongklakIndonesiaGame
//
//  Created by Elfa Andika on 10/02/21.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupAnimation()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    private func setupAnimation() {
        animationView = .init(name: K.launchLottie)
        animationView?.frame = view.bounds
        animationView?.backgroundColor = #colorLiteral(red: 0.9966183305, green: 0.9112530947, blue: 0.8029767275, alpha: 1)
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.play()
        view.addSubview(animationView!)
        view.sendSubviewToBack(animationView!)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            self.performSegue(withIdentifier: K.homeSegue, sender: nil)
        })
        
        
        }
    
}
