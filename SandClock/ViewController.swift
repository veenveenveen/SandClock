//
//  ViewController.swift
//  SandClock
//
//  Created by 黄启明 on 2017/4/19.
//  Copyright © 2017年 黄启明. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sandClockView: SandClockView?

    override func viewDidLoad() {
        super.viewDidLoad()
        sandClockView = SandClockView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sandClockView?.center = view.center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func startAnimation(_ sender: Any) {
        sandClockView?.showAnimation()
        view.addSubview(sandClockView!)
    }

    @IBAction func stopAnimation(_ sender: Any) {
        sandClockView?.removeAnimation()
        sandClockView?.removeFromSuperview()
        print("stop")
    }
}

