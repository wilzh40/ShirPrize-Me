//
//  SecondViewController.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/15/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    let singleton:Singleton = Singleton.sharedInstance

    @IBOutlet  var address: UITextField?
    @IBOutlet  var city: UITextField?
    @IBOutlet  var state: UITextField?
    @IBOutlet  var zip: UITextField?
   
    override func viewDidLoad() {
        super.viewDidLoad()
             // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

