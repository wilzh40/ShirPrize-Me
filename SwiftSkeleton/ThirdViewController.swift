//
//  ThirdViewController.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/17/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import Foundation
import UIKit


class ThirdViewController: UIViewController {
    let singleton:Singleton = Singleton.sharedInstance
    
    @IBOutlet  var stepper:UIStepper?
    @IBOutlet  var quantity: UILabel?
    @IBOutlet  var size: UIButton?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSizeButton (sender:AnyObject) {
        if size?.titleLabel.text == "med" {
            size?.setTitle("lrg", forState: UIControlState.Normal)
        }
        if size?.titleLabel.text == "sma" {
            size?.setTitle("med", forState: UIControlState.Normal)
        }
        if size?.titleLabel.text == "lrg" {
            size?.setTitle("sma", forState: UIControlState.Normal)
        }
        singleton.quoteObject.product.size = size!.titleLabel.text!
    }
    @IBAction func oneStep (sender:AnyObject) {
        quantity?.text = "\(Int(stepper!.value))"
        singleton.quoteObject.product.quantity = Int(stepper!.value)
    }
    @IBAction func loading (sender:AnyObject) {
        
        self.insertSpinner(YYSpinkitView(style:YYSpinKitViewStyle.Pulse,color:UIColor.whiteColor()),
            atIndex:4,backgroundColor:UIColor(red:0.498,green:0.549,blue:0.553,alpha:1.0))
    }
    func insertSpinner(spinner:YYSpinkitView,atIndex index:Int,backgroundColor color:UIColor){
        var screenBounds = UIScreen.mainScreen().bounds
        var screenWidth = CGRectGetWidth(screenBounds)
        var panel = UIView(frame:CGRectOffset(screenBounds, screenWidth * CGFloat(index), 0.0))
        panel.backgroundColor = color
        spinner.center = CGPointMake(CGRectGetMidX(screenBounds), CGRectGetMidY(screenBounds))
        panel.addSubview(spinner)
        self.view.addSubview(panel)
    }
      
}

