//
//  FourthViewController.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/17/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import Foundation
import UIKit

class FourthViewController: UIViewController {
    let singleton:Singleton = Singleton.sharedInstance
    
    @IBOutlet  var totalPrice:UILabel?
    @IBOutlet  var pricePerShirt:UILabel?
    @IBOutlet  var progressBar:UIProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var randomNumber = arc4random()%200000
        var randomImage:UIImage = singleton.getImageFromUrl("https://openclipart.org/image/200px/svg_to_png/\(randomNumber)/write2.png")
        
        self.progressBar?.setProgress(0.1, animated: true)
        while (randomImage == nil ){
            //If its lower
            var randomNumber = arc4random()%200000
            randomImage = singleton.getImageFromUrl("https://openclipart.org/image/200px/svg_to_png/\(randomNumber)/write2.png")
        }
        self.progressBar?.setProgress(0.35, animated: true)
        
        // imgFromUrl.image = randomImage
        singleton.artworkPath = "https://openclipart.org/image/200px/svg_to_png/\(randomNumber)/write2"
        singleton.artwork = randomImage
        
        //singleton.artworkPath = ("@\(singleton.documentsDirectoryPath)/artwork.png")
        //singleton.saveImage(imgFromUrl.image, fileName: "artwork", type: "png", directory: singleton.documentsDirectoryPath)
        println("ImagePushed")
        
        singleton.designObject.artwork = singleton.artworkPath
        singleton.designPost()
        
      //  progressBar.val
        totalPrice?.text = "\(singleton.totalPrice)"
        pricePerShirt?.text = "\(singleton.pricePerUnit)"
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    
}

