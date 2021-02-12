//
//  CustomButton.swift
//  CongklakIndonesiaGame
//
//  Created by Elfa Andika on 11/02/21.
//

import UIKit

class SlotCongklakPlayer1: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 15
        layer.backgroundColor = #colorLiteral(red: 0.3599766195, green: 0.291559577, blue: 0.2623854876, alpha: 1)
        layer.cornerRadius = 15
        layer.borderWidth = 2
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel?.tintColor = .white
    }
}
