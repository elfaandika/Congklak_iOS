//
//  SlotCongklakPlayer2.swift
//  CongklakIndonesiaGame
//
//  Created by Elfa Andika on 11/02/21.
//

import UIKit

class SlotCongklakPlayer2: SlotCongklakPlayer1 {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }

}
