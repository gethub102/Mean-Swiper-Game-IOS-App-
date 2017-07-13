//  Name: Wenbin Li Course: CSE651
//  Assignment number: hwG
//
//  Matrix.swift
//  MineSweeper
//
//  Created by Lee on 4/9/16.
//  Copyright © 2016 Wenbin Li. All rights reserved.
//
//  16 * 16 (15% ~ 20%) = 38.4 ~ 51.2 = 39 ~ 51

import Foundation
// This is a class of 10 * 10 matrix
// the matrix is to store position of mine image
// position of mine image is random
class BlockMatrix {
    var my2Darr = [[Int]]()  //2 dimension arry to store the element
    var count : Int = 0      //statistic the block image number
    var m_row: Int = 0       //give angel image a random initial position
    
    //initial the random data, clear the path to bottom, and keep number of block img is 15% ~ 20%
    init() {
        for _ : Int in 0..<16 { //initial all the elements value of zero
            var arr = [Int]()
            for _ : Int in 0..<16 {
                arr.append(0)
            }
            my2Darr.append(arr)
        }
        // give the matrix random number of element with value of one
        for i : Int in 0..<16 {
            var blockNum = Int(arc4random_uniform(UInt32(4))+1)
            while(blockNum > 0){
                let j = Int(arc4random_uniform(UInt32(16)))
                if my2Darr[i][j] != 1 {
                    my2Darr[i][j] = 1
                    blockNum--;
                    ++count
                    print("my2Darr[\(i)][\(j)] = 1, count = \(count)")
                }
            }
        }
                
        //keep the number of block image is in the range of 15% ~ 20%
        while(count < 39) {
            let tmpi : Int = Int(arc4random_uniform(UInt32(15)) + 1)
            let tmpj : Int = Int(arc4random_uniform(UInt32(15)) + 1)
            if  (my2Darr[tmpi][tmpj] != 1) {
                my2Darr[tmpi][tmpj] = 1
                ++count
                print("125: my2Darr[\(tmpi)][\(tmpj)] = 1, count = \(count)")
            }
            if count > 38 {
                break
            }
        }
        while (count > 51) {
            let tmpi : Int = Int(arc4random_uniform(UInt32(15)) + 1)
            let tmpj : Int = Int(arc4random_uniform(UInt32(15)) + 1)
            if (my2Darr[tmpi][tmpj] == 1) {
                my2Darr[tmpi][tmpj] = 0
                --count
                print("137: my2Darr[\(tmpi)][\(tmpj)] = 0, count = \(count)")
            }
            if count < 52 {
                break
            }
        }
        
        // make sure angel and devil donot overlap at first
        m_row = Int(arc4random_uniform(UInt32(9)))
        while(my2Darr[m_row][0] == 1) {
            m_row = Int(arc4random_uniform(UInt32(9)))
        }
        
    }
    // update the elements value according to index y
    func moveUp(inout my2Darr : [[Int]]) {
        var tmpArr : [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        //init the tmp arry
        for i:Int in 0..<10 {
            tmpArr[i] = my2Darr[i][0]
        }
        //update the value of element according to index y
        for y:Int in 0..<9 {
            for x:Int in 0..<10 {
                my2Darr[x][y] = my2Darr[x][y + 1]
            }
        }
        //update the last line value
        for x:Int in 0..<10 {
            my2Darr[x][9] = tmpArr[x]
        }
    }
}