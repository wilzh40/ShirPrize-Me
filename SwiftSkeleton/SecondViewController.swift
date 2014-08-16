//
//  SecondViewController.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/15/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,SideMenuDelegate {
    let singleton:Singleton = Singleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleton.sideMenu = SideMenu(sourceView: self.view, menuData: ["A","B","C","D"])
        // Do any additional setup after loading the view, typically from a nib.
        singleton.sideMenu!.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenuDidSelectItemAtIndex(index: Int) {
        singleton.sideMenu?.toggleMenu()
     //   self.performSegueWithIdentifier("Show1", sender: self)
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        singleton.sideMenu?.toggleMenu()
    }

    
}

