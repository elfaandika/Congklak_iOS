//
//  HomeViewController.swift
//  CongklakIndonesiaGame
//
//  Created by Elfa Andika on 11/02/21.
//

import UIKit

class HomeViewController: UIViewController {

   
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var baseView: UIView!
    var vc = CongklakViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logoImage.layer.cornerRadius = 10
        logoImage.layer.opacity = 0.9
        baseView.layer.cornerRadius = 5
        baseView.layer.opacity = 0.9
        
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
