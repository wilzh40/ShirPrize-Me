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
    
    var artwork:UIImage = UIImage()
    var artworkPath:NSString = ""
    var documentsDirectoryPath:NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString

    
    
    
    var designObject:DesignObject = DesignObject()
    var quoteObject:QuoteObject = QuoteObject()
    
    var designID:String = ""
    var orderToken:String = ""
  
    var address:Address = Address()
    var totalPrice:Double = 0
    var pricePerUnit:Double = 0
    
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
    func quotePost () {
        
        var url = "https://api.scalablepress.com/v2/quote"
        
        var post = SwiftNetworkingClient.post(url, params:
            ["type":"\(quoteObject.type)","designId":"\(self.designID)","sides[front]":"\(quoteObject.sides.front)","sides[back]":"\(quoteObject.sides.back)","sides[left]":"\(quoteObject.sides.left)","sides[right]":"\(quoteObject.sides.left)","products[0][id]":"\(quoteObject.product.id)","products[0][color]":"\(quoteObject.product.color)","products[0][size]":"\(quoteObject.product.size)","products[0][quantity]":"\(quoteObject.product.quantity)","address[name]":"\(address.name)","address[address1]":"\(address.address)","address[city]":"\(address.city)","address[state]":"\(address.state)","address[zip]":"\(address.zip)"]
            ).onComplete({results -> Void in
                println(results)
                let json = JSON.parse(results)
                self.orderToken = json["orderToken"].asString!
                self.totalPrice = json["total"].asDouble!
                self.pricePerUnit = json["total"].asDouble!/Double(self.quoteObject.product.quantity)
                
                println("Order Token:\(self.orderToken)")
            }).onError({error -> Void in
                println("Error!")
            })
        post.go()
     
    }
    
    func designPost () {
        var url = "https://api.scalablepress.com/v2/design"
        var post = SwiftNetworkingClient.post(url, params:
            ["type":"\(designObject.type)","name":"\(designObject.name)","sides[front][colors][0]":"\(designObject.color)","sides[front][artwork]":"\(designObject.artwork)","sides[front][dimensions][width]":"\(designObject.width)"/*,"sides[front][dimensions][height]":"\(designObject.height)"*/]
            ).onComplete({results -> Void in
                println(results)

                let json = JSON.parse(results)
                self.designID = json["designId"].asString!
                self.quoteObject.designId = json["designId"].asString!
                println(self.designID)
                self.quotePost()

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
    
    
    
    
    
    
    
    
       func getImageFromUrl(urlString:NSString) -> UIImage {
        var result:UIImage
        var err:NSError?
        var url:NSURL = NSURL.URLWithString(urlString)
        var data:NSData = NSData.dataWithContentsOfURL(url, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        if data == nil {
            println("no connection")
        }
        if err != nil {
            println(err)
        }
        return UIImage(data: data)
    }
    
    func saveImage(image:UIImage,fileName:NSString,type:NSString,directory:NSString) {
        var err:NSError?
        println("Saving at \(directory)/\(fileName).\(type)")
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
        println("Loading \(directory)/\(fileName).\(type)")
        var data: AnyObject! = NSData.dataWithContentsOfMappedFile("\(directory)/\(fileName).\(type)")
        var result:UIImage = UIImage(data: data as NSData)
        return result
        
    }

   
}

class DesignObject : NSObject {
    var name:String? = "a"
    var type:String = "dtg"
    var color:String = "White" //Color
    var artwork:String = "white"
    var width:Float = 5;
    var height:Float = 7
}


class QuoteObject : NSObject {
    var type:String = ""
    var designId:String = ""
    var sides:Sides = Sides.init()
    var product = OrderObject()
    
    override init() {
        type = "dtg"
        designId = "nil"
        sides.front = 1
        product.id = "american-apparel-t-shirt"
        product.quantity = 1
    }
    
}
class Address : NSObject {
    var name:String = "Joe Schlomo"
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
    var color:String = "White"
    var size:String = "med"
    var quantity:Int = 0
    
}