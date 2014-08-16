//
//  Singleton.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 8/15/14.
//  Copyright (c) 2014 Wilson Zhao. All rights reserved.
//

import Foundation

class Singleton {
    
    class var sharedInstance : Singleton {
    struct Static {
        static let instance : Singleton = Singleton()
        }
        return Static.instance
    }
    
    var sideMenu:SideMenu?
    var apikey:String? = "17b03c3c38a23a46df62d0d8bb68665a"
    
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
   
}

class QuoteObject : NSObject {
    var type:String = ""
    var designId:String = ""
    var sides:Sides = Sides.init()
    var product = OrderObject()
    
    override init() {
        
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