//
//  FifthViewController.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/17/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//
import UIKit
class FifthViewController: UIViewController {
    let singleton:Singleton = Singleton.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        singleton.orderPost()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
    }
    
}
