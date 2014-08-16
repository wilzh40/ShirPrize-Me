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
   
}
