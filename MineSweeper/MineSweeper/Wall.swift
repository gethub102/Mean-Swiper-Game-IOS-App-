//  Name: Wenbin Li Course: CSE651
//  Assignment number: hwG
//
//  Wall.swift
//  MineSweeper
//
//  Created by Lee on 4/9/16.
//  Copyright © 2016 Wenbin Li. All rights reserved.
//

import Foundation

//element for draw flag and wall
class Wall {
    var flag : Int = 0;
    var draw : Int = 1;
    var opened: Int = 0;
    var numOfMineNeigb : Int = 0;
    var beNumed : Int = 0;
}

//container of wall elements
class WallMatrix {
    var wallMatrix = [[Wall]]() //describe the cell situation
    var needOpenedNum : Int = 0 //the num should be opened
    var openedNum : Int = 0     //statistic the number of opened cell
    //initial the element for 2d arry
    init(){
        for _ : Int in 0..<16 {
            var tmpwall_arr = [Wall]()
            for _: Int in 0..<16 {
                let tmpwall = Wall()
                tmpwall_arr.append(tmpwall)
            }
            wallMatrix.append(tmpwall_arr)
        }
    }
}