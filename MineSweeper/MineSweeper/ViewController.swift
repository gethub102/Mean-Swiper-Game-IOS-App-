//  Name: Wenbin Li Course: CSE651
//  Assignment number: hwG
//
//  ViewController.swift
//  MineSweeper
//
//  Created by Lee on 4/9/16.
//  Copyright © 2016 Wenbin Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var myview: MyView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGrayColor()
        // Do any additional setup after loading the view, typically from a nib.
        
         //create gesture recognizer, with associated gesture handler
        let tapDoubleGR = UITapGestureRecognizer(target: self, action: Selector("tapDoubleHandler:"))
        tapDoubleGR.numberOfTapsRequired = 2           // set appropriate GR attributes
        myview.addGestureRecognizer(tapDoubleGR)           // add GR to view
        
        //---< Single Tap Gesture Recognizer >---------------
        let tapSingleGR = UITapGestureRecognizer(target: self, action: "tapSingleHandler:")
        tapSingleGR.numberOfTapsRequired = 1           // set appropriate GR attributes
        tapSingleGR.requireGestureRecognizerToFail(tapDoubleGR)  // prevent single tap recognition on double-tap
        myview.addGestureRecognizer(tapSingleGR)                     // add GR to view
        
        //---< Long press Gesture Recognizer >---------------
        let longPressGR = UILongPressGestureRecognizer(target: self, action: Selector("longPressHandler:"))
        longPressGR.minimumPressDuration = 1           // must hold for 1 second
        longPressGR.allowableMovement = 15             // can move touch 15 points w/o auto-cancellation
        myview.addGestureRecognizer(longPressGR)


    }
    
    //-----< Double tap to uncover the cell >-------------------
    func tapDoubleHandler(sender: UITapGestureRecognizer) {
        if ( sender.state == UIGestureRecognizerState.Ended ) {
            var touchRow : Int = 0;  var touchCol : Int = 0
            let xy : CGPoint
            xy = sender.locationInView(myview)
            myview.x = xy.x;  myview.y = xy.y
            touchRow = Int(myview.x / myview.dw);  touchCol = Int(myview.y / myview.dh)
            if  myview.wall_obj.wallMatrix[touchRow][touchCol].draw == 1 && myview.wall_obj.wallMatrix[touchRow][touchCol].flag == 0 {
                myview.openCell(touchRow, y: touchCol)
            }
            print("Double tap from viewcontroller")
            
            myview.row = touchRow;  myview.col = touchCol
            if myview.blockMatrix.my2Darr[myview.row][myview.col] == 1 && myview.wall_obj.wallMatrix[myview.row][myview.col].opened == 1 {
                myview.backgroundColor = UIColor.redColor()
            }else {
                myview.backgroundColor = UIColor.darkGrayColor()
            }
            myview.setNeedsDisplay()   // request view re-draw

        }
    }
    

    //---< single tap to flag the cell >-------------------
    func tapSingleHandler(sender: UITapGestureRecognizer) {
        if ( sender.state == UIGestureRecognizerState.Ended ) {
            var touchRow : Int = 0;  var touchCol : Int = 0
            let xy : CGPoint
            xy = sender.locationInView(myview)
            myview.x = xy.x;  myview.y = xy.y
            touchRow = Int(myview.x / myview.dw);  touchCol = Int(myview.y / myview.dh)
            if myview.wall_obj.wallMatrix[touchRow][touchCol].opened == 0 && myview.wall_obj.wallMatrix[touchRow][touchCol].flag == 0 {
                myview.wall_obj.wallMatrix[touchRow][touchCol].flag = 1
            }
            else if myview.wall_obj.wallMatrix[touchRow][touchCol].opened == 0 && myview.wall_obj.wallMatrix[touchRow][touchCol].flag == 1 {
                myview.wall_obj.wallMatrix[touchRow][touchCol].flag = 0
            }
            print("Single tap from viewcontroller")
            
            myview.row = touchRow;  myview.col = touchCol
            if myview.blockMatrix.my2Darr[myview.row][myview.col] == 1 && myview.wall_obj.wallMatrix[myview.row][myview.col].opened == 1 {
                myview.backgroundColor = UIColor.redColor()
            }else {
                myview.backgroundColor = UIColor.darkGrayColor()
            }
            myview.setNeedsDisplay()   // request view re-draw

        }
    }
    
    //--< Long press the screen to restart the game >------------
    func longPressHandler(sender: UITapGestureRecognizer) {
        if (  sender.state == .Ended ) {
            let restartblockMatrix = BlockMatrix()
            let restartwall_obj = WallMatrix()
            myview.blockMatrix = restartblockMatrix
            myview.wall_obj = restartwall_obj
            myview.initialNeigbNum()
            myview.wall_obj.needOpenedNum = 256 - myview.blockMatrix.count
            for  spot:UIImageView in myview.spots {
                spot.removeFromSuperview()
            }
            print(" Long press handler to restart the game ")
            myview.setNeedsDisplay()
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

