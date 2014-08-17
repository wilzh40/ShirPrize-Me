//
//  ImageSaver.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/16/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import Foundation
import UIKit

class ImageSaver {
    
    var documentsDirectoryPath:NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
    func getImageFromUrl(urlString:NSString) -> UIImage {
        var result:UIImage
        var err:NSError?
        var url:NSURL = NSURL.URLWithString(urlString)
        var data:NSData = NSData.dataWithContentsOfURL(url, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        
        if err != nil {
            println(err)
        }
        return UIImage(data: data)
    }
    
    func saveImage(image:UIImage,fileName:NSString,type:NSString,directory:NSString) {
        var err:NSError?
        if type.lowercaseString == "png" {
            UIImagePNGRepresentation(image).writeToFile(directory.stringByAppendingPathComponent("\(fileName).png"), options:NSDataWritingOptions.DataWritingAtomic, error: &err)
            }
        else if type.lowercaseString == "jpg" || type.lowercaseString == "jpeg" {
          UIImageJPEGRepresentation(image,1.0).writeToFile(directory.stringByAppendingPathComponent("\(fileName).jpg"), options:NSDataWritingOptions.DataWritingAtomic, error: &err)
        } else {
            println("Image Save Failed \(type)")
            
        }
    }
    func loadImage(fileName:NSString,type:String,directory:NSString) -> UIImage {
        var result:UIImage = NSData.dataWithContentsOfMappedFile("\(directory)/\(fileName).\(type)") as UIImage
        return result
        
    }
    
}