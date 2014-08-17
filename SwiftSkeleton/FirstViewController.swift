//
//  FirstViewController.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/15/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, SideMenuDelegate,FrostedSidebarDelegate {
       
    
    let imagePicker:UIImagePickerController = UIImagePickerController()
    let singleton:Singleton = Singleton.sharedInstance

    
    

     @IBOutlet var imgFromUrl:UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        imgFromUrl.image = singleton.getImageFromUrl("http://developer.apple.com/icloud/images/storage-backup.png")
        singleton.initFrostedSidebar()
        singleton.frostedSidebar!.delegate = self
       // imagePicker.delegate = self;
    
        
        
    
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
    @IBAction func onBurger() {
        singleton.frostedSidebar!.showInViewController(self, animated: true)
    }
    @IBAction func presentImagePicker(sender: AnyObject){
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func newImage () {
        var randomNumber = arc4random()%200000
        var randomImage:UIImage = singleton.getImageFromUrl("https://openclipart.org/image/200px/svg_to_png/\(randomNumber)/write2.png")
    
        while (randomImage == nil ){
            //If its lower
            var randomNumber = arc4random()%200000
            randomImage = singleton.getImageFromUrl("https://openclipart.org/image/200px/svg_to_png/\(randomNumber)/write2.png")
        }
        imgFromUrl.image = randomImage
        singleton.artworkPath = "https://openclipart.org/image/200px/svg_to_png/\(randomNumber)/write2.png"
    }
    @IBAction func saveImage () {
        singleton.artwork = imgFromUrl.image
      
        //singleton.artworkPath = ("@\(singleton.documentsDirectoryPath)/artwork.png")
        singleton.saveImage(imgFromUrl.image, fileName: "artwork", type: "png", directory: singleton.documentsDirectoryPath)
        println("Image Saved!")
        
        println("Pushed")
        
        singleton.designObject.artwork = singleton.artworkPath
        singleton.designPost()
        
    }
    func sidebar(sidebar: FrostedSidebar, willShowOnScreenAnimated animated: Bool){
        
    }
    func sidebar(sidebar: FrostedSidebar, didShowOnScreenAnimated animated: Bool){
        
    }
    func sidebar(sidebar: FrostedSidebar, willDismissFromScreenAnimated animated: Bool){
        
    }
    func sidebar(sidebar: FrostedSidebar, didDismissFromScreenAnimated animated: Bool){
        
    }
    func sidebar(sidebar: FrostedSidebar, didTapItemAtIndex index: Int){
        
    }
    func sidebar(sidebar: FrostedSidebar, didEnable itemEnabled: Bool, itemAtIndex index: Int){
        
    }

    

}

