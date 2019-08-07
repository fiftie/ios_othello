//
//  ViewController.swift
//  othello
//
//  Created by 五十嵐 龍吉 on 2019/08/04.
//  Copyright © 2019 五十嵐 龍吉. All rights reserved.
//

import UIKit

struct Color {
  let green: UIColor = UIColor.init(red: 75/255, green: 165/255, blue: 45/255, alpha: 1)
  let lightGreen: UIColor = UIColor.init(red: 100/255, green: 210/255, blue: 200/255, alpha: 1)
  let black: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
  let white: UIColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
}
struct Piece {
  let black: Int = 1
  let white: Int = 2
  let sentinel: Int = 3
}
let BlockSize: Int = 40
let PieceSize: Int = 36

var Board: [UIButton] = []
var Pieces: [UILabel] = []

/**
 *  black 1
 *  white 2
 *  番兵 3
 **/
var BoardInfo: [[Int]] = [
  [3,3,3,3,3,3,3,3,3,3],
  [3,0,0,0,0,0,0,0,0,3],
  [3,0,0,0,0,0,0,0,0,3],
  [3,0,0,0,0,0,0,0,0,3],
  [3,0,0,0,2,1,0,0,0,3],
  [3,0,0,0,1,2,0,0,0,3],
  [3,0,0,0,0,0,0,0,0,3],
  [3,0,0,0,0,0,0,0,0,3],
  [3,0,0,0,0,0,0,0,0,3],
  [3,3,3,3,3,3,3,3,3,3],
]

// 黒が先攻
var Turn: Int = 1;

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    Board = initBoard()
    Pieces = initPieces()
    supportPuttable()
    // viewに追加する
    for i in 0...63 {
      self.view.addSubview(Board[i])
      self.view.addSubview(Pieces[i])
    }
  }
  
  func initBoard() -> [UIButton] {
    // UIButtonのインスタンスを作成する
    var board: [UIButton] = []
    let color = Color()
    var i: Int = 0
    for y in 0...7 {
      for x in 0...7 {
        board.append(UIButton(type: UIButton.ButtonType.system))
        board[i].backgroundColor = color.green
        board[i].tag = i
        board[i].addTarget(self, action: #selector(boardTapEvent(_:)), for: UIControl.Event.touchUpInside)
        // サイズを変更する
        board[i].frame = CGRect(x: 0, y: 0, width: BlockSize, height: BlockSize)
        board[i].layer.borderWidth = 1.0
        // 任意の場所に設置する
        let xp: Int = x*BlockSize+BlockSize/2
        let yp: Int = y*BlockSize+100
        board[i].layer.position = CGPoint(x: xp, y: yp)
        i+=1
      }
    }
    return board
  }
  
  func initPieces() -> [UILabel] {
    // UIButtonのインスタンスを作成する
    var pieces: [UILabel] = []
    let color = Color()
    var i: Int = 0
    for y in 0...7 {
      for x in 0...7 {
        pieces.append(UILabel())
        if x==3 && y==3 || x==4 && y==4 {
          pieces[i].backgroundColor = color.white
        }else if x==4 && y==3 || x==3 && y==4 {
          pieces[i].backgroundColor = color.black
        }else{
          pieces[i].backgroundColor = color.green
        }
        pieces[i].layer.masksToBounds = true
        pieces[i].layer.cornerRadius = CGFloat(PieceSize/2)
        // サイズを変更する
        pieces[i].frame = CGRect(x: 0, y: 0, width: PieceSize, height: PieceSize)
        // 任意の場所に設置する
        let xp: Int = x*BlockSize+BlockSize/2
        let yp: Int = y*BlockSize+100
        pieces[i].layer.position = CGPoint(x: xp, y: yp)
        i+=1
      }
    }
    return pieces
  }
  
  func checkPiece(index: Int, isFlip: Bool) -> Bool {
    // 番兵分1足す
    let x: Int = index%8+1
    let y: Int = index/8+1
    var isFirst: Bool = true
    var isSettable: Bool = false
    for _y in -1...1 {
      for _x in -1...1 {
        var _boardInfo: [[Int]] = BoardInfo
        for i in 1...8 {
          let yIndex: Int = y+_y*i
          let xIndex: Int = x+_x*i
          if BoardInfo[yIndex][xIndex] == Piece().sentinel { break }
          if isFirst {
            if BoardInfo[yIndex][xIndex] == 3-Turn {
              isFirst = false
              if isFlip {
                _boardInfo[yIndex][xIndex] = Turn
              }
            }else{
              break
            }
          }else{
            if BoardInfo[yIndex][xIndex] == 3-Turn {
              _boardInfo[yIndex][xIndex] = Turn
            }else if BoardInfo[yIndex][xIndex] == Turn {
              _boardInfo[y][x] = Turn
              isSettable = true
              break
            }
          }
        }
        if isFlip {
          BoardInfo = _boardInfo
        }
      }
    }
    if isFlip { reloadPieces() }
    return isSettable
  }
  
  func reloadPieces() {
    var i: Int = 0
    for y in 1...8 {
      for x in 1...8 {
        if BoardInfo[y][x] == Piece().black {
          Pieces[i].backgroundColor = Color().black
        }else if BoardInfo[y][x] == Piece().white {
          Pieces[i].backgroundColor = Color().white
        }
        i+=1
      }
    }
  }
  
  func supportPuttable() {
    for i in 0...63 {
      if checkPiece(index: i, isFlip: false) {
        Board[i].backgroundColor = Color().lightGreen
      }
    }
  }
  
  @objc func boardTapEvent(_ sender: UIButton) {
    let i: Int = sender.tag
    if checkPiece(index: i, isFlip: true) {
      Turn = 3-Turn
    }
  }
}

