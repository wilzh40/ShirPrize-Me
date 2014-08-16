//
//  FirstViewController.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/15/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, SideMenuDelegate{
   
    let singleton:Singleton = Singleton.sharedInstance
    var qo:QuoteObject = QuoteObject()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        singleton.sideMenu = SideMenu(sourceView: self.view, menuData: ["A","B","C","D"])
        // Do any additional setup after loading the view, typically from a nib.
        singleton.sideMenu!.delegate = self
       
        singleton.quotePost(qo)
        
              
             //  singleton.textExample()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func testQuote() {
        
    }

    func sideMenuDidSelectItemAtIndex(index: Int) {
        singleton.sideMenu?.toggleMenu()
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("1") as UIViewController;
        
        //let navigationController = UINavigationController(rootViewController: vc)

       // self.presentViewController(navigationController, animated: true, completion: nil)
        self.navigationController.setViewControllers([vc], animated: false)

 //   self.addChildViewController(vc)
    
    }

    @IBAction func toggleSideMenu(sender: AnyObject) {
        singleton.sideMenu?.toggleMenu()
    }
}

