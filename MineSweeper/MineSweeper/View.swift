//  Name: Wenbin Li Course: CSE651
//  Assignment number: hwG
//
//  View.swift
//  MineSweeper
//
//  Created by Lee on 4/9/16.
//  Copyright © 2016 Wenbin Li. All rights reserved.
//

import UIKit

class MyView: UIView {
    
    var dw : CGFloat = 0;  var dh : CGFloat = 0    // width and height of cell
    var x : CGFloat = 0;   var y : CGFloat = 0     // touch point coordinates
    var row : Int = 0;     var col : Int = 0       // selected cell in cell grid
    var inMotion : Bool = false                    // true iff in process of dragging
    var restart : Bool = false                     // restart the game
    var blockMatrix = BlockMatrix()                // 2 D arry for storing mine
    var wall_obj = WallMatrix()                    // 2 D arry for storing statue
    var first: Bool = true   //bool flag to prevent angel and block image overlap at the beginning
    var move_first: Bool = true //bool flag to prevent angel and final image overlap at the beginning
    var firstInitialNumOfMineNeigb :Bool = true
    var spots : [UIImageView] = []
    
    //initial the Num Of Mine Neigb
    func initialNeigbNum() {
        //initial the Num Of Mine Neigb
        if firstInitialNumOfMineNeigb == true {
            firstInitialNumOfMineNeigb = true
            for  i: Int in 0..<16 {
                for  j:Int in 0..<16 {
                    if blockMatrix.my2Darr[i][j] != 1 {
                        if i - 1 >= 0 && j - 1 >= 0 {
                            if blockMatrix.my2Darr[i-1][j-1] == 1 {
                                wall_obj.wallMatrix[i][j].numOfMineNeigb++
                            }
                            
                        }
                        if j - 1 >= 0 {
                            if blockMatrix.my2Darr[i][j-1] == 1 {
                                wall_obj.wallMatrix[i][j].numOfMineNeigb++
                            }
                            
                        }
                        if i + 1 < 16 && j - 1 >= 0 {
                            if blockMatrix.my2Darr[i+1][j-1] == 1 {
                                wall_obj.wallMatrix[i][j].numOfMineNeigb++
                            }
                        }
                        if i + 1 < 16 {
                            if blockMatrix.my2Darr[i + 1][j] == 1 {
                                wall_obj.wallMatrix[i][j].numOfMineNeigb++
                            }
                        }
                        if i + 1 < 16 && j + 1 < 16 {
                            if blockMatrix.my2Darr[i + 1][j + 1] == 1 {
                                wall_obj.wallMatrix[i][j].numOfMineNeigb++
                            }
                        }
                        if j + 1 < 16 {
                            if blockMatrix.my2Darr[i][j + 1] == 1 {
                                wall_obj.wallMatrix[i][j].numOfMineNeigb++
                            }
                        }
                        if i - 1 >= 0 && j + 1 < 16 {
                            if blockMatrix.my2Darr[i - 1][j + 1] == 1 {
                                wall_obj.wallMatrix[i][j].numOfMineNeigb++
                            }
                        }
                        if i - 1 >= 0 {
                            if blockMatrix.my2Darr[i - 1][j] == 1 {
                                wall_obj.wallMatrix[i][j].numOfMineNeigb++
                            }
                        }
                    }
                }
            }
        }
    }
    
    //initial frame
    override init(frame: CGRect) {
        print( "init(frame)" )
        super.init(frame: frame)
    }
    
    //initial coder
    required init?(coder aDecoder: NSCoder) {
        print( "init(coder)" )
        row = blockMatrix.m_row
        print("angel initial positon: [\(row)][0]")
        
        super.init(coder: aDecoder)
        initialNeigbNum()
        wall_obj.needOpenedNum = 256 - blockMatrix.count
    }
    
    
    // draw the view of application
    override func drawRect(rect: CGRect) {
        print( "drawRect:" )
        
        let context = UIGraphicsGetCurrentContext()!  // obtain graphics context
        // CGContextScaleCTM( context, 0.5, 0.5 )  // shrink into upper left quadrant
        let bounds = self.bounds          // get view's location and size
        let w = CGRectGetWidth( bounds )   // w = width of view (in points)
        let h = CGRectGetHeight( bounds ) // h = height of view (in points)
        self.dw = w/16.0                      // dw = width of cell (in points)
        self.dh = h/16.0                      // dh = height of cell (in points)
        
        print( "view (width,height) = (\(w),\(h))" )
        print( "cell (width,height) = (\(self.dw),\(self.dh))" )
        
        // draw lines to form a 16x16 cell grid
        CGContextBeginPath( context )               // begin collecting drawing operations
        for i in 1..<16 {
            // draw horizontal grid line
            let iF = CGFloat(i)
            CGContextMoveToPoint( context, 0, iF*(self.dh) )
            CGContextAddLineToPoint( context, w, iF*self.dh )
        }
        for i in 1..<16 {
            // draw vertical grid line
            let iFlt = CGFloat(i)
            CGContextMoveToPoint( context, iFlt*self.dw, 0 )
            CGContextAddLineToPoint( context, iFlt*self.dw, h )
        }
        UIColor.grayColor().setStroke()                        // use gray as stroke color
        CGContextDrawPath( context, CGPathDrawingMode.Stroke ) // execute collected drawing ops
        
        //print statistic num
        print("mine image count: \(blockMatrix.count)")
        print("need to be opened cell num: \(wall_obj.needOpenedNum)")
        
        //place the mine image according to the matrix element value equals 1
        for  i: Int in 0..<16 {
            for  j:Int in 0..<16 {
                if blockMatrix.my2Darr[j][i] == 1 {
                    // establish bounding box for block image
                    let imageRect_block = CGRectMake(self.dw * CGFloat(j), self.dh * CGFloat(i), self.dw, self.dh)
                    let imgblock : UIImage?
                    imgblock = UIImage(named: "mine")
                    //draw the block image
                    imgblock!.drawInRect(imageRect_block)
                }
            }
        }
        
        //draw  Mine Neigb num picture
        for  i: Int in 0..<16 {
            for  j:Int in 0..<16 {
                let imgRect_neigbNum = CGRectMake(self.dw * CGFloat(i), self.dh * CGFloat(j), self.dw, self.dh)
                let imgneigbNum : UIImage?
                if wall_obj.wallMatrix[i][j].numOfMineNeigb == 0{}
                else if wall_obj.wallMatrix[i][j].numOfMineNeigb == 1 {
                    imgneigbNum = UIImage(named: "one")
                    imgneigbNum!.drawInRect(imgRect_neigbNum)
                    wall_obj.wallMatrix[i][j].beNumed = 1
                }
                else if wall_obj.wallMatrix[i][j].numOfMineNeigb == 2 {
                    imgneigbNum = UIImage(named: "two")
                    imgneigbNum!.drawInRect(imgRect_neigbNum)
                    wall_obj.wallMatrix[i][j].beNumed = 1
                }
                else if wall_obj.wallMatrix[i][j].numOfMineNeigb == 3 {
                    imgneigbNum = UIImage(named: "three")
                    imgneigbNum!.drawInRect(imgRect_neigbNum)
                    wall_obj.wallMatrix[i][j].beNumed = 1
                }
                else if wall_obj.wallMatrix[i][j].numOfMineNeigb == 4 {
                    imgneigbNum = UIImage(named: "four")
                    imgneigbNum!.drawInRect(imgRect_neigbNum)
                    wall_obj.wallMatrix[i][j].beNumed = 1
                }
            }
        }
        
        
        //place the wall and flag img in screen
        for i:Int in 0..<16 {
            for j:Int in 0..<16 {
                if wall_obj.wallMatrix[i][j].draw == 1 {
                    let imgRect_wall = CGRectMake(self.dw * CGFloat(i), self.dh * CGFloat(j), self.dw, self.dh)
                    var imgwall : UIImage?

                    if wall_obj.wallMatrix[i][j].opened != 1 {
                        if wall_obj.wallMatrix[i][j].draw == 1 {
                            //choose the wall img
                            imgwall = UIImage(named: "wall.png")
                        }
                        if wall_obj.wallMatrix[i][j].flag == 1 {
                            //choose the flag img
                            imgwall = UIImage(named: "flag_.png")
                        }
                        imgwall!.drawInRect(imgRect_wall)
                    }
                }
            }
        }
    }
    
    
    
    //----------- < Recursion open the cell >-----------------------
    func openCell(x : Int, y : Int) -> Bool{
        if (x < 0 || x > 15) || (y < 0 || y > 15) {      // range the index
            return false
        }
        else if wall_obj.wallMatrix[x][y].opened == 1 {
            return false
        }
        else {
            wall_obj.wallMatrix[x][y].draw = 0
            wall_obj.wallMatrix[x][y].opened = 1
            wall_obj.openedNum++
            if blockMatrix.my2Darr[x][y] == 1 { //open one mine cell to ---< lose game >------------------
                let imgblock : UIImage?
                imgblock = UIImage(named: "lose")
                let block_view = UIImageView( image:imgblock )
                self.addSubview( block_view )
                block_view.frame = CGRectMake(self.dw * CGFloat(7), self.dh * CGFloat(6), self.dw * 2, self.dh * 2)
                spots.append( block_view ) // add the spot to the spots array
                //-------- < open all the mine cells > -------
                for i:Int in 0..<16 {
                    for j:Int in 0..<16 {
                        if blockMatrix.my2Darr[i][j] == 1 {
                            wall_obj.wallMatrix[i][j].draw = 0
                            wall_obj.wallMatrix[i][j].opened = 1
                        }
                    }
                }
            }
            else if wall_obj.openedNum == wall_obj.needOpenedNum { // ---< to win the game >--------------
                let imgblock : UIImage?
                imgblock = UIImage(named: "win")
                let block_view = UIImageView( image:imgblock )
                self.addSubview( block_view )
                block_view.frame = CGRectMake(self.dw * CGFloat(7), self.dh * CGFloat(6), self.dw * 2, self.dh * 2)
                spots.append( block_view ) // add the spot to the spots array
            }
            if wall_obj.wallMatrix[x][y].numOfMineNeigb == 0 && blockMatrix.my2Darr[x][y] != 1 {
                
                openCell( x - 1, y: y );
                openCell( x - 1, y: y - 1 );
                openCell( x, y: y - 1 );
                openCell( x + 1, y: y - 1 );
                openCell( x + 1, y: y );
                openCell( x + 1, y: y + 1 );
                openCell( x , y: y + 1 );
                openCell( x - 1, y: y + 1 );
            }

        }
    return true;
    }
}