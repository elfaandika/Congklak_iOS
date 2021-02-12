//
//  CongklakPresenter.swift
//  CongklakIndonesiaGame
//
//  Created by Elfa Andika on 11/02/21.
//

import UIKit

enum GoalPlayer {
    case Player1
    case Player2
    case NotBase
}
enum PlayerSession {
    case Player1
    case Player2
}

protocol CongklakPresenterDelegate {
    func updateUI(slot: [Int], pointer: Int?, marble: Int?)
    func firstUILoad(slot: [Int])
    func getSession(session: PlayerSession)
    func getWinner(description: String)
}

class CongklakPresenter {
    
    var congklakPresenterDelegate: CongklakPresenterDelegate?
    
    let dataCongklak = CongklakModel(slot: [7,7,7,7,7,7,7,0,7,7,7,7,7,7,7,0])
    var congklakA = CongklakModel(slot: [7,7,7,7,7,7,7,0,7,7,7,7,7,7,7,0])
    
    func setViewDelegate(congklakPresenterDelegate: CongklakPresenterDelegate) {
        self.congklakPresenterDelegate = congklakPresenterDelegate
    }
    func firstLoad() {
        congklakPresenterDelegate?.firstUILoad(slot: congklakA.slot)
    }
    
    func resetGame() {
        congklakA = dataCongklak
    }
    
    // MARK:- Shoot Enemy
    func takeEnemyMarble(lastPointer i: Int, session player: PlayerSession) {
        let goalReference = 7
        var goalIndex: Int {
            return player == .Player1 ? 7 : 15
        }
        let range = goalReference - i
        let enemyIndex = goalReference + range
        
        if congklakA.slot[enemyIndex] == 0 {
            return
        }
        else {
            let sumMarble = congklakA.slot[enemyIndex] + congklakA.slot[i]
            
            updateCongklak(pointer: enemyIndex, addMarble: nil, holdMarble: nil)
            updateCongklak(pointer: i, addMarble: nil, holdMarble: nil)
            updateCongklak(pointer: goalIndex, addMarble: sumMarble, holdMarble: nil)
        }
    }
    
    // MARK:- Respon Tap Button User
    func playerButtonTap(buttonIndex i: Int, completion: @escaping ((PlayerSession,Bool))->Void) {
        let playerSession = sessionCheck(tapIndex: i)
        let marbleAmount = congklakA.slot[i]

        congklakPresenterDelegate?.getSession(session: playerSession)
        if marbleAmount != 0 {
            playCongklak(buttonIndex: i, marbleAmount: marbleAmount, session: playerSession){ (session) in
                completion(session)
            }
        }
        return
    }
    
    // MARK:- Check Congklak Slot Status
    func baseCheck(index i: Int) -> GoalPlayer{
        if (Double(i) + 2)/8 == 1 {
            return GoalPlayer.Player1
        }else if (Double(i) + 2)/8 == 2 {
            return GoalPlayer.Player2
        }
        return GoalPlayer.NotBase
    }
    
    // MARK:- Check Session by Congklak Slot Index
    func sessionCheck(tapIndex i: Int) -> PlayerSession {
        if (Double(i) + 1)/8 <= 1 {
            return PlayerSession.Player1
        }else {
            return PlayerSession.Player2
        }
    }
    
    // MARK:- Update Data and Update UI
    func updateCongklak(pointer p: Int, addMarble m: Int?, holdMarble h: Int?) {
        var marble = 0
        if let temp = h {
           marble = temp-1 == -1 ? 0:temp-1
        }
        if let amount = m {
            congklakA.slot[p] += amount
        }
        else {
            congklakA.slot[p] = 0
        }
        congklakPresenterDelegate?.updateUI(slot: congklakA.slot, pointer: p, marble: marble)
    }
    
    // MARK:- Check Empty Player Congklak Slot
    func emptyPlayerSlotCheck() {
        let sumPlayer1Slot = congklakA.sumPlayer1Slot
        let sumPlayer2Slot = congklakA.sumPlayer2Slot
        
        if sumPlayer1Slot == 0 || sumPlayer2Slot == 0 {
            congklakA.flushPlayer2Slot()
            congklakA.flushPlayer1Slot()
            congklakPresenterDelegate?.updateUI(slot: congklakA.slot, pointer: 0, marble: 0)
            winGameCheck()
        }
    }
    
    // MARK:- Check Winner
    func winGameCheck() {
        typealias p = PlayerSession
        let scorePlayer1 = congklakA.goalPlayer1
        let scorePlayer2 = congklakA.goalPlayer2
        
        if scorePlayer1 > 49 || scorePlayer2 > 49
        {
            let winner = scorePlayer1 > scorePlayer2 ? p.Player1:p.Player2
            congklakPresenterDelegate?.getWinner(description: "\(winner) Win!")
        }
        else if scorePlayer1 == scorePlayer2 {
            congklakPresenterDelegate?.getWinner(description: "Player 1 and Player 2 Draw!")
        }
    }
    
    // MARK:- Main Logic Congklak
    func playCongklak(buttonIndex i: Int, marbleAmount m: Int, session player: PlayerSession, completion: @escaping ((PlayerSession,Bool))->Void) {
        var tempSession = (PlayerSession.Player1,true)
        var holdMarble = m
        var pointer = i
        
        updateCongklak(pointer: pointer, addMarble: nil, holdMarble: holdMarble)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true){ [self] t in
            //Increase normal congklak slot
            if baseCheck(index: pointer) == .NotBase && holdMarble != 0 {
                updateCongklak(pointer: pointer + 1, addMarble: 1, holdMarble: holdMarble)
                
                if congklakA.slot[pointer + 1] == 1 && holdMarble == 1 {
                    if sessionCheck(tapIndex: pointer + 1) == player {
                        takeEnemyMarble(lastPointer: pointer + 1, session: player)
                    }
                }
                tempSession = (player,false)
            }
            //Increase base congklak slot for Player 1
            else if baseCheck(index: pointer) == .Player1 && player == .Player1{
                updateCongklak(pointer: pointer + 1, addMarble: 1, holdMarble: holdMarble)
                if holdMarble == 1 {
                    tempSession = (player,true)
                }
            }
            //Increase base congklak slot for Player 2
            else if baseCheck(index: pointer) == .Player2 && player == .Player2{
                updateCongklak(pointer: pointer + 1, addMarble: 1, holdMarble: holdMarble)
                if holdMarble == 1 {
                    tempSession = (player,true)
                }
            }
            //to skip enemy base congklak slot
            else {
                holdMarble += 1
            }
            
            holdMarble -= 1
            pointer += 1
            
            //Increase hold marble if last marble add into non empty slot
            if holdMarble == 0 && baseCheck(index: pointer - 1) == .NotBase && congklakA.slot[pointer] != 1 && congklakA.slot[pointer] != 0 {
                holdMarble = congklakA.slot[pointer]
                updateCongklak(pointer: pointer, addMarble: nil, holdMarble: holdMarble)
            }
            //reset pointer
            if pointer == congklakA.slot.count - 1 {
                pointer = -1
            }
            emptyPlayerSlotCheck()
            
            //Stop loop after holdmarble isEmpty
            if holdMarble == 0 {
                t.invalidate()
                completion(tempSession)
            }
        }
        
    }
    
}
