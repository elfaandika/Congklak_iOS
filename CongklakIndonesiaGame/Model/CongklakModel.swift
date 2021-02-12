//
//  CongklakModel.swift
//  CongklakIndonesiaGame
//
//  Created by Elfa Andika on 11/02/21.
//

import Foundation

struct CongklakModel {
    
    var slot: [Int]
    var sumPlayer1Slot: Int {
        return slot[0...6].reduce(0,+)
    }
    var sumPlayer2Slot: Int {
        return slot[8...14].reduce(0,+)
    }
    var goalPlayer1: Int {
        return slot[7]
    }
    var goalPlayer2: Int {
        return slot[15]
    }

    mutating func flushPlayer1Slot() {
        slot[7] += sumPlayer1Slot
        for i in 0...6 {
            slot[i] = 0
        }
    }
    mutating func flushPlayer2Slot() {
        slot[15] += sumPlayer2Slot
        for i in 8...14 {
            slot[i] = 0
        }
    }
}
