//
//  FirstViewController.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/15/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, SideMenuDelegate {
   
    
    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    
    let singleton:Singleton = Singleton.sharedInstance
    var qo:QuoteObject = QuoteObject()
    
    

     @IBOutlet var imgFromUrl:UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        singleton.sideMenu = SideMenu(sourceView: self.view, menuData: ["A","B","C","D"])
        // Do any additional setup after loading the view, typically from a nib.

        imgFromUrl.image = singleton.getImageFromUrl("https://developer.apple.com/icloud/images/storage-backup.png")


        
        singleton.sideMenu!.delegate = self
       // imagePicker.delegate = self;
    
        
        qo.type = "screenprint"
        singleton.designPost(singleton.designObject)
        //singleton.quotePost(qo)

        
              
             //  singleton.textExample()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    func sideMenuDidSelectItemAtIndex(index: Int) {
        singleton.sideMenu?.toggleMenu()
        
        switch index {
       
        case 1:
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("1") as UIViewController;
        
        //let navigationController = UINavigationController(rootViewController: vc)

       // self.presentViewController(navigationController, animated: true, completion: nil)
            self.navigationController.setViewControllers([vc], animated: false)
            break
        case 2:
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            break
        default:
            break
        }
 //   self.addChildViewController(vc)
    
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        print(info[UIImagePickerControllerReferenceURL])
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        print ("x")
    }
    @IBAction func toggleSideMenu(sender: AnyObject) {
        singleton.sideMenu?.toggleMenu()
    }
    
    @IBAction func presentImagePicker(sender: AnyObject){
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
}

