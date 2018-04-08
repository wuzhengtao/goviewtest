//
//  BoardSize.swift
//  goviewtest
//
//  Created by 吴正涛 on 2018/4/6.
//  Copyright © 2018年 吴正涛. All rights reserved.
//

import Foundation
import UIKit

class BoardSize {
//    60, 49, 22, 15, 42
    var up = 0, down = 0, left = 0, right = 0, size = 0;
    var array = [[Int]]()
    func BoardSize(up : Int, down : Int, left : Int, right : Int, size : Int) {
        self.up = up
        self.left = left
        self.right = right
        self.down = down
        self.size = size
        for i in array {
            for var j in i {
                j = 0;
            }
        }
    }
    
    //得到一个屏幕上的坐标，转换成最近的点上的坐标。
    func cgpoint2board(input : CGPoint) -> CGPoint {
        let inputx = input.x
        let inputy = input.y
        let tempx = ((inputx - CGFloat(left)) / CGFloat(size)).rounded()
        let tempy = ((inputy - CGFloat(up)) / CGFloat(size)).rounded()
//        if (array[Int(tempx)][Int(tempy)] != 1) {
//            return CGPoint.zero
//        }
        let outputx = tempx * CGFloat(size) + CGFloat(left) - 20
        let outputy = tempy * CGFloat(size) + CGFloat(up) - 20
        return CGPoint(x: outputx, y:outputy)
    }
    
//    func addPoint(point : CGPoint) {
//        let pointx = point.x
//        let pointy = point.y
//        let tempx = ((pointx - CGFloat(left)) / CGFloat(size)).rounded()
//        let tempy = ((pointy - CGFloat(up)) / CGFloat(size)).rounded()
//        array[Int(tempx)][Int(tempy)] = 1;
//    }
    
}
