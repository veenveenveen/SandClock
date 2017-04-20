//
//  SandClockView.swift
//  SandClock
//
//  Created by 黄启明 on 2017/4/20.
//  Copyright © 2017年 黄启明. All rights reserved.
//

import UIKit

let SandClock_length: CGFloat = 30.0
let SandClock_duration: Double = 3.0

class SandClockView: UIView {
    //沙漏宽度
    var width: CGFloat {
        return CGFloat(sqrtf(Float(SandClock_length * SandClock_length + SandClock_length * SandClock_length))) * 0.8
    }
    //沙漏总高度为 height*2
    var height: CGFloat {
        return CGFloat(sqrtf(Float(SandClock_length * SandClock_length - (width / 2) * (width / 2))))
    }

    var containerLayer: CALayer!//沙漏父容器
    var topLayer: CAShapeLayer!//沙漏上半部分
    var bottomLayer: CAShapeLayer!//沙漏下半部分
    var lineLayer: CAShapeLayer!//沙漏 漏线
    
    var frameLayer: CAShapeLayer!//沙漏 漏线
    
    var containerAnimation: CAKeyframeAnimation!
    var topAnimation: CAKeyframeAnimation!
    var bottomAnimation: CAKeyframeAnimation!
    var lineAnimation: CAKeyframeAnimation!
    
    //加载说明文字
    var loadingLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContainerLayer()
        setupTopLayer()
        setupBottomLayer()
        setupLineLayer()
        setupFrameLayer()
        setupLoadingLabel()
        
        setupAnimation()
        showAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //设置沙漏父容器
    fileprivate func setupContainerLayer() {
        
        containerLayer = CALayer()
        containerLayer.backgroundColor = UIColor.clear.cgColor
        containerLayer.frame = CGRect(x: 0, y: 0, width: width, height: height * 2)
        containerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        containerLayer.position = self.center
        self.layer.addSublayer(containerLayer)
    }
    //设置沙漏上半部分
    fileprivate func setupTopLayer() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        bezierPath.addLine(to: CGPoint(x: width / 2, y: height))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        topLayer = CAShapeLayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        topLayer.path = bezierPath.cgPath
        topLayer.fillColor = UIColor.orange.cgColor
        topLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        topLayer.position = CGPoint(x: width / 2, y: height)
        containerLayer.addSublayer(topLayer)
    }
    //设置沙漏下半部分
    fileprivate func setupBottomLayer() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: width / 2, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: 0, y: height))
        bezierPath.addLine(to: CGPoint(x: width / 2, y: 0))
        bezierPath.close()
        
        bottomLayer = CAShapeLayer()
        bottomLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        bottomLayer.path = bezierPath.cgPath
        bottomLayer.fillColor = UIColor.orange.cgColor
        bottomLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        bottomLayer.position = CGPoint(x: width / 2, y: height * 2)
        containerLayer.addSublayer(bottomLayer)
    }
    //设置沙漏 漏线
    fileprivate func setupLineLayer() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: width / 2, y: 0))
        bezierPath.addLine(to: CGPoint(x: width / 2, y: height))
        
        lineLayer = CAShapeLayer()
        lineLayer.frame = CGRect(x: 0, y: height, width: width, height: height)
        lineLayer.path = bezierPath.cgPath
        lineLayer.strokeColor = UIColor.orange.cgColor
        lineLayer.lineWidth = 1.0
        lineLayer.lineJoin = kCALineJoinMiter//设置线段的链接方式棱角 kCALineJoinMiter;平滑 kCALineJoinRound;折线 kCALineJoinBevel;
        lineLayer.lineDashPattern = [NSNumber(value: 2.0), NSNumber(value: 1.0)]
        //设置线段的宽度为2 间距为1 这个数组中还可以继续添加，会循环进行设置 例如 5 2 1 3 则第一条线段5px，间距2px，第二条线段1px 间距3px再开始第一条线段
        lineLayer.lineDashPhase = 0.0//设置从哪个位置开始
        lineLayer.strokeEnd = 0.0
        containerLayer.addSublayer(lineLayer)
    }
    //设置沙漏边框 ⏳
    fileprivate func setupFrameLayer() {
        //图形1 带边框
//        let bezierPath = UIBezierPath()
//        bezierPath.move(to: CGPoint(x: 0, y: 0))
//        bezierPath.addLine(to: CGPoint(x: width, y: 0))
//        bezierPath.addLine(to: CGPoint(x: width, y: height * 2))
//        bezierPath.addLine(to: CGPoint(x: 0, y: height * 2))
//        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
//        bezierPath.move(to: CGPoint(x: 0, y: 0))
//        bezierPath.addLine(to: CGPoint(x: width, y: height * 2))
//        bezierPath.move(to: CGPoint(x: width, y: 0))
//        bezierPath.addLine(to: CGPoint(x: 0, y: height * 2))
//        bezierPath.close()
        //图形2
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: height * 2))
        bezierPath.addLine(to: CGPoint(x: width, y: height * 2))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        frameLayer = CAShapeLayer()
        frameLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        frameLayer.path = bezierPath.cgPath
        frameLayer.strokeColor = UIColor.lightGray.cgColor
        frameLayer.lineWidth = 2.0
        frameLayer.fillColor = UIColor.clear.cgColor
        frameLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        frameLayer.position = CGPoint(x: width / 2, y: height)
        containerLayer.addSublayer(frameLayer)
    }
    //设置动画
    fileprivate func setupAnimation() {
        //top 动画 按比例放大缩小动画
        topAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        topAnimation.duration = SandClock_duration
        topAnimation.repeatCount = MAXFLOAT
        topAnimation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 0.6), NSNumber(value: 0.9), NSNumber(value: 1.0)]
        topAnimation.values = [NSNumber(value: 1.0), NSNumber(value: 0.4), NSNumber(value: 0.0), NSNumber(value: 0.0)]
        //bottom 动画 按比例放大缩小动画
        bottomAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bottomAnimation.duration = SandClock_duration
        bottomAnimation.repeatCount = MAXFLOAT
        bottomAnimation.keyTimes = [NSNumber(value: 0.12), NSNumber(value: 0.9), NSNumber(value: 1.0)]
        bottomAnimation.values = [NSNumber(value: 0.05), NSNumber(value: 1.0), NSNumber(value: 1.0)]
        //line 动画 颜色从无到有
        lineAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        lineAnimation.duration = SandClock_duration
        lineAnimation.repeatCount = MAXFLOAT
        lineAnimation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 0.12), NSNumber(value: 0.9), NSNumber(value: 1.0)]
        lineAnimation.values = [NSNumber(value: 0.0), NSNumber(value: 1.0), NSNumber(value: 1.0), NSNumber(value: 1.0)]
        //container 动画 按z轴旋转动画
        containerAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        containerAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.1, 1, 0.8, 0.0)
        containerAnimation.duration = SandClock_duration
        containerAnimation.repeatCount = MAXFLOAT
        containerAnimation.keyTimes = [NSNumber(value: 0.8), NSNumber(value: 1.0)]
        containerAnimation.values = [NSNumber(value: 0.0), NSNumber(value: Double.pi)]
    }
    
    //设置说明文字
    fileprivate func setupLoadingLabel() {
        loadingLabel = UILabel()
        loadingLabel?.text = "loading..."
        loadingLabel?.textColor = UIColor.orange
        loadingLabel?.font = UIFont.systemFont(ofSize: 16.0)
        loadingLabel?.numberOfLines = 0
        loadingLabel?.sizeToFit()
        loadingLabel?.center.x = self.center.x
        loadingLabel?.frame.origin.y = self.center.y + SandClock_length + 5
        
        self.addSubview(loadingLabel!)
    }
    //展示动画
    func showAnimation() {
        topLayer.add(topAnimation, forKey: "topAnimation")
        bottomLayer.add(bottomAnimation, forKey: "bottomAniamtion")
        lineLayer.add(lineAnimation, forKey: "lineAnimation")
        containerLayer.add(containerAnimation, forKey: "containerAnimation")
    }
    //移除动画
    func removeAnimation() {
        topLayer.removeAllAnimations()
        bottomLayer.removeAllAnimations()
        lineLayer.removeAllAnimations()
        containerLayer.removeAllAnimations()
    }
}
