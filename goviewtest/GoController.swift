//
//  ViewController.swift
//  goviewtest
//
//  Created by 吴正涛 on 2018/3/30.
//  Copyright © 2018年 吴正涛. All rights reserved.
//

import UIKit

class GoController : UIViewController {
    
    var myTimer : Int = 1
    
    var havePoint : Bool = false
    var turn : Bool = true
    var haveGo : Bool = true
    
    var up : Bool = true
    
    var newpoint : UIImageView?
    
    var startPoint : CGPoint?
    var ps : CGPoint?
    var pe : CGPoint?
    
    var totalTime : Int = 0
    
    let boardSize = BoardSize()

    @IBOutlet var back: UIView!
    @IBOutlet weak var bv: UIButton!
    
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var pointview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bv.adjustsImageWhenHighlighted = false
        boardSize.BoardSize(up: 53, down: 49, left: 20, right: 15, size: 36)
        totalTime = myTimer * 1000
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        changeStatus()
    }
    
    @IBAction func touchStart(_ sender: UIButton, forEvent event: UIEvent) {
        let point = event.allTouches?.first?.location(in: bv)
        let boardPoint = boardSize.cgpoint2board(input: point!)
        pe = boardPoint
        up = false
        if !havePoint {
            newPoint(cg: boardPoint, view: bv)
            startPoint = boardPoint
            ps = newpoint?.frame.origin
            havePoint = true
            if !haveGo {
                totalTime = myTimer * 1000
                gdcTimer()
            }
            
        } else {
            startPoint = point
            ps = newpoint?.frame.origin
        }
    }
    
    @IBAction func change(_ sender: UIButton) {
        haveGo = !haveGo;
        if haveGo {
            btnChange.setTitle("有 go按钮", for: .normal)
            btnGo.alpha = 1
        } else {
            btnChange.setTitle("没 go按钮", for: .normal)
            btnGo.alpha = 0
        }
    }
    
    @IBAction func startTime(_ sender: UIButton) {
        checkpoint()
        if !haveGo {
            totalTime = myTimer * 1000
            up = true
        }
    }
    @IBAction func movePoint(_ sender: UIButton, forEvent event: UIEvent) {
        up = false
        if havePoint {
            let endPoint = event.allTouches?.first?.location(in: bv)
            pe = boardSize.cgpoint2board(input: addCGPoint(a: subCGPoint(a: endPoint!, b: startPoint!), b: ps!))
            if (pe == CGPoint.zero) {
                return
            }
            
            newpoint?.transform = __CGAffineTransformMake(1, 0, 0, 1, (pe?.x)!, (pe?.y)!)
        }
    }
    
    //计时器
    func gdcTimer() {
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:      DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(10))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 每秒计时一次
            if self.up {
                self.totalTime = self.totalTime - 10
            }
            // 时间到了取消时间源
            if self.totalTime <= 0 {
                // 返回主线程处理一些事件，更新UI等等
                DispatchQueue.main.async {
                    self.changeStatus()
                }
                self.totalTime = self.myTimer
                codeTimer.cancel()
            }
            
        })
        // 启动时间源
        codeTimer.resume()
    }
    
    func newPoint (cg : CGPoint, view : UIView) {
        let color : UIImage
        if turn {
            color = #imageLiteral(resourceName: "black")
        } else {
            color = #imageLiteral(resourceName: "white")
        }
        let subview = UIImageView(image: color)
        subview.transform.tx = cg.x
        subview.transform.ty = cg.y
        view.addSubview(subview)
        newpoint = subview
    }
    
    func changeStatus () {
        if havePoint {
            havePoint = false
            turn = !turn
            boardSize.addPoint(point: (newpoint?.frame.origin)!)
            changepoint()
        }
    }
    
    func checkpoint() {
        let point = newpoint?.frame.origin
        if (point?.x)! > CGFloat(288) ||
            (point?.x)! < CGFloat(0) ||
            (point?.y)! > CGFloat(321) ||
            (point?.y)! < CGFloat(33) {
            havePoint = false
            newpoint?.removeFromSuperview()
        }
    }
    
    func changepoint() {
        if turn {
            pointview.image = #imageLiteral(resourceName: "black")
        } else {
            pointview.image = #imageLiteral(resourceName: "white")
        }
    }
    
    func subCGPoint(a : CGPoint, b : CGPoint) -> CGPoint {
        return CGPoint(x:(a.x) - (b.x),y:(a.y) - (b.y));
    }
    
    func addCGPoint(a : CGPoint, b : CGPoint) -> CGPoint {
        return CGPoint(x:(a.x) + (b.x),y:(a.y) + (b.y));
    }
}
