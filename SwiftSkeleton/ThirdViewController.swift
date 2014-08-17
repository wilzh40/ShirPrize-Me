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
    
  
    
    
}

