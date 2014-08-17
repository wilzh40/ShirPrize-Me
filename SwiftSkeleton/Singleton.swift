//
//  Singleton.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/15/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import Foundation
import UIKit
class Singleton {
    
    class var sharedInstance : Singleton {
    struct Static {
        static let instance : Singleton = Singleton()
        }
        return Static.instance
    }
    
    var sideMenu:SideMenu?
    var apikey:String? = "17b03c3c38a23a46df62d0d8bb68665a"
    
    var designObject:DesignObject = DesignObject()
    
    
    
    var quoteParam:NSDictionary = ["0":"0"]
    var orderParam:NSDictionary = ["0":"0"]
    
    /*
    func textExample () {
        var url = "https://api.scalablepress.com/v2/products/gildan-sweatshirt-crew"
        var getTracksRequest = SwiftNetworkingClient.get(url).onComplete({result -> Void in
            /*var parsedSongs = parseJSON(result)["results"]
            println(parsedSongs)
            
            var parsedSongsArr = parsedSongs!
            
            for song : [String: JSONVal] in parsedSongsArr {
            println(song)
            }*/
            
            var songs = parseJSON(result)["results"]
            //var songsArr = songs.val() as [String : Any]
            var songsArr = songs.val()
            println(songsArr)
            //for song in songsArr {
            //    println(song)
            //}
            
            
        }).onError({error -> Void in
            println("ERROR RECEIVED")
        })
        
        getTracksRequest.go()
        
    } */
    func quotePost (qo:QuoteObject) {
        
        var url = "https://api.scalablepress.com/v2/quote"
        var post = SwiftNetworkingClient.post(url, params:
            ["type":"\(qo.type)","designId":"\(qo.designId)","sides[front]":"\(qo.sides.front)","sides[back]":"\(qo.sides.back)","sides[left]":"\(qo.sides.left)","sides[right]":"\(qo.sides.left)","products[0][id]":"\(qo.product.id)","products[0][color]":"\(qo.product.color)","products[0][size]":"\(qo.product.size)","products[0][quantity]":"\(qo.product.quantity)"]
            ).onComplete({results -> Void in
                println(results)
            }).onError({error -> Void in
                println("Error!")
            })
        post.go()

    }
    
    func designPost (qo:DesignObject) {
        var url = "https://api.scalablepress.com/v2/design"
        var post = SwiftNetworkingClient.post(url, params:
            ["type":"\(qo.type)","name":"\(qo.name)","sides[front][color]":"\(qo.color)","sides[front][artwork]":"\(qo.artwork)"]
            ).onComplete({results -> Void in
                println(results)
            }).onError({error -> Void in
                println("Error!")
            })
        post.go()
    }
    
    func jsonify (dict: NSDictionary) -> NSString {
        var str = ""
        for (key,val) in dict {
            str += "\(key)=\(val)&"
        }
        return str
    }
    
    
    
    
    
    
    
    
    ///*****IMAGE SAVING******???
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

class DesignObject : NSObject {
    var name:String? = "a"
    var type:String = "b"
    var color:String = "Red" //Color
    var artwork:String = "white"
    
}


class QuoteObject : NSObject {
    var type:String = ""
    var designId:String = ""
    var sides:Sides = Sides.init()
    var product = OrderObject()
    
    override init() {
        type = "screenprint"
        designId = "nil"
        sides.front = 1
        product.id = ""
        product.quantity = 1
    }
    
}
class Address : NSObject {
    var name:String = "W"
    var company:String?
    var address:String = "43419 Mission Siena Circle"
    var address2:String?
    var city:String = "Fremont"
    var state:String = "CA"
    var zip:Int = 99999
    var country:String?

}
class Sides: NSObject {
    var front:Int
    var back:Int
    var left:Int
    var right:Int
    
    var valid:Bool {
        if front + back + left + right > 0 {
            return true
            }
        else {
            return false
            }
    }
    override init() {
        front = 0; back=0;left=0;right=0;
    }
}
class OrderObject : NSObject {
    var id:String = ""
    var color:String?
    var size:String?
    var quantity:Int = 0
    
}