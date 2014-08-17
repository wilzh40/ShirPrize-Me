//
//  QJSON.swift
//  AccessControl
//
//  Created by Jameson Quave on 7/25/14.
//  Copyright (c) 2014 JQ Software. All rights reserved.
//

import Foundation
/*
func parseJSON(data: NSData) -> JSONVal {
    return JSON(data).parse()
}

func parseJSON(str: String) -> JSONVal {
    return JSON(str).parse()
}
*/
public enum JSONVal : Printable {
    
    // Generator protocol, use for `for x in y`
//    typealias Element
    /*public func next() -> JSONVal? {
        return self
    }
    typealias GeneratorType = JSONVal
    */
    
    /*
protocol Sequence {
typealias GeneratorType : Generator
func generate() -> GeneratorType
}
*/
    /*typealias GeneratorType = JSONVal
    func generate() -> GeneratorType {
        return GeneratorType(0)
    }
    func next() -> JSONVal {
        return JSONVal("hi")
    }
    */
    
    public func val() -> Any {
        switch self {
        case .Dictionary(let dict):
            return dict
        case .JSONDouble(let d):
            return d
        case .JSONInt(let i):
            return i
        case .JSONArray(let arr):
            return arr
        case .JSONStr(let str):
            return str
        case .JSONBool(let jbool):
            return jbool
        case .Null:
            return "Null"
        }
    }
    
    case Dictionary([String : JSONVal])
    case JSONDouble(Double)
    case JSONInt(Int)
    case JSONArray([JSONVal])
    case JSONStr(String)
    case JSONBool(Bool)
    case Null
    
    
    // Pretty prints for Dictionary and Array
    
    func pp(data : [String : JSONVal]) -> String {
        return "DICT"
    }
    
    func pp(data : [JSONVal]) -> String {
        var str = "[\n"
        var indentation = "  "
        for x : JSONVal in data {
            str += "\(indentation)\(x)\n"
        }
        return str
    }
    
    public var description: String {
        switch self {
        case .Dictionary(let dict):
            var str = "{\n"
            var indent = "  "
            for (key,val) in dict {
                str += "\(indent)\(key):  \(val)\n"
            }
            return "JSONDictionary \(str)"
        case .JSONDouble(let d):
            return "\(d)"
        case .JSONInt(let i):
            return "\(i)"
        case .JSONArray(let arr):
            var str = "[\n"
            var num = 0
            var indent = "  "
            for object in arr {
                str += "[\(num)]\(indent)\(object.description)\n"
                num++
            }
            str += "]"
            return "JSONArray [\(arr.count)]: \(str)"
        case .JSONStr(let str):
            return str
        case .JSONBool(let jbool):
            return "\(jbool)"
        case .Null:
            return "Null"
        }
    }
    
    subscript(index: String) -> JSONVal {
        switch self {
            case .Dictionary(let dict):
                if dict[index]? != nil {
                    return dict[index]!
                }
                return JSONVal("JSON Fault")
            
            default:
                println("Element is not a dictionary")
                return JSONVal("JSON Fault")
        }
    }
    
    subscript(index: Int) -> JSONVal {
        switch self {
            case .JSONArray(let arr):
                return arr[index]
            default:
                println("Element is not an array")
                return JSONVal("JSON Fault")
        }
    }
    
    init(_ json: Int) {
        self = .JSONInt(json)
    }
    
    init(_ json: AnyObject) {

        if let jsonDict = json as? NSDictionary {
                var kvDict = [String : JSONVal]()
                for (key: AnyObject, value: AnyObject) in jsonDict {
                    if let keyStr = key as? String {
                        kvDict[keyStr] = JSONVal(value)
                    }
                    else {
                        println("Error: key in dictionary is not of type String")
                    }
                }
                self = .Dictionary(kvDict)
        }
        else if let jsonDouble = json as? Double {
            self = .JSONDouble(jsonDouble)
        }
        else if let jsonInt = json as? Int {
            self = .JSONInt(jsonInt)
        }
        else if let jsonBool = json as? Bool {
            self = .JSONBool(jsonBool)
        }
        else if let jsonStr = json as? String {
            self = .JSONStr(jsonStr)
        }
        else if let jsonArr = json as? NSArray {
            var arr = [JSONVal]()
            
            for val in jsonArr {
                arr.append(JSONVal(val))
            }
            
            self = .JSONArray( arr )
        }
        else {
            println("ERROR: Couldn't convert element \(json)")
            self = .Null
        }

    }
}
public class JSON {
    private let _value:AnyObject
    /// pass the object that was returned from
    /// NSJSONSerialization
    public init(_ obj:AnyObject) { self._value = obj }
    /// pass the JSON object for another instance
    public init(_ json:JSON){ self._value = json._value }
}
/// class properties
extension JSON {
    public typealias NSNull = Foundation.NSNull
    public typealias NSError = Foundation.NSError
    public class var null:NSNull { return NSNull() }
    /// pases string to the JSON object
    public class func parse(str:String)->JSON {
        var err:NSError?
        let enc = NSUTF8StringEncoding
        var obj:AnyObject? = NSJSONSerialization.JSONObjectWithData(
            str.dataUsingEncoding(enc), options:nil, error:&err
        )
        return err != nil ? JSON(err!) : JSON(obj!)
    }
    /// fetch the JSON string from NSURL
    public class func fromNSURL(nsurl:NSURL) -> JSON {
        var enc:NSStringEncoding = NSUTF8StringEncoding
        var err:NSError?
        let str:String? =
        NSString.stringWithContentsOfURL(
            nsurl, usedEncoding:&enc, error:&err
        )
        return err != nil ? JSON(err!) : JSON.parse(str!)
    }
    /// fetch the JSON string from URL in the string
    public class func fromURL(url:String) -> JSON {
        return self.fromNSURL(NSURL.URLWithString(url))
    }
    /// does what JSON.stringify in ES5 does.
    /// when the 2nd argument is set to true it pretty prints
    public class func stringify(obj:AnyObject, pretty:Bool=false) -> String! {
        if !NSJSONSerialization.isValidJSONObject(obj) {
            JSON(NSError(
                domain:"JSONErrorDomain",
                code:422,
                userInfo:[NSLocalizedDescriptionKey: "not an JSON object"]
                ))
            return nil
        }
        return JSON(obj).toString(pretty:pretty)
    }
}
/// instance properties
extension JSON {
    /// access the element like array
    public subscript(idx:Int) -> JSON {
        switch _value {
        case let err as NSError:
            return self
        case let ary as NSArray:
            if 0 <= idx && idx < ary.count {
                return JSON(ary[idx]!)
            }
            return JSON(NSError(
                domain:"JSONErrorDomain", code:404, userInfo:[
                    NSLocalizedDescriptionKey:
                    "[\(idx)] is out of range"
                ]))
        default:
            return JSON(NSError(
                domain:"JSONErrorDomain", code:500, userInfo:[
                    NSLocalizedDescriptionKey: "not an array"
                ]))
            }
    }
    /// access the element like dictionary
    public subscript(key:String)->JSON {
        switch _value {
        case let err as NSError:
            return self
        case let dic as NSDictionary:
            if let val:AnyObject = dic[key] { return JSON(val) }
            return JSON(NSError(
                domain:"JSONErrorDomain", code:404, userInfo:[
                    NSLocalizedDescriptionKey:
                    "[\"\(key)\"] not found"
                ]))
        default:
            return JSON(NSError(
                domain:"JSONErrorDomain", code:500, userInfo:[
                    NSLocalizedDescriptionKey: "not an object"
                ]))
            }
    }
    /// access json data object
    public var data:AnyObject? {
        return self.isError ? nil : self._value
    }
    /// Gives the type name as string.
    /// e.g. if it returns "Double"
    /// .asDouble returns Double
    public var type:String {
        switch _value {
        case is NSError: return "NSError"
        case is NSNull: return "NSNull"
        case let o as NSNumber:
            switch String.fromCString(o.objCType)! {
            case "c", "C": return "Bool"
            case "q", "l", "i", "s": return "Int"
            case "Q", "L", "I", "S": return "UInt"
            default: return "Double"
            }
        case is NSString: return "String"
        case is NSArray: return "Array"
        case is NSDictionary: return "Dictionary"
        default: return "NSError"
            }
    }
    /// check if self is NSError
    public var isError: Bool { return _value is NSError }
    /// check if self is NSNull
    public var isNull: Bool { return _value is NSNull }
    /// check if self is Bool
    public var isBool: Bool { return type == "Bool" }
    /// check if self is Int
    public var isInt: Bool { return type == "Int" }
    /// check if self is UInt
    public var isUInt: Bool { return type == "UInt" }
    /// check if self is Double
    public var isDouble: Bool { return type == "Double" }
    /// check if self is any type of number
    public var isNumber: Bool {
        if let o = _value as? NSNumber {
            let t = String.fromCString(o.objCType)!
            return t != "c" && t != "C"
            }
            return false
    }
    /// check if self is String
    public var isString: Bool { return _value is NSString }
    /// check if self is Array
    public var isArray: Bool { return _value is NSArray }
    /// check if self is Dictionary
    public var isDictionary: Bool { return _value is NSDictionary }
    /// check if self is a valid leaf node.
    public var isLeaf: Bool {
        return !(isArray || isDictionary || isError)
    }
    /// gives NSError if it holds the error. nil otherwise
    public var asError:NSError? {
        return _value as? NSError
    }
    /// gives NSNull if self holds it. nil otherwise
    public var asNull:NSNull? {
        return _value is NSNull ? JSON.null : nil
    }
    /// gives Bool if self holds it. nil otherwise
    public var asBool:Bool? {
        switch _value {
        case let o as NSNumber:
            switch String.fromCString(o.objCType)! {
            case "c", "C": return Bool(o.boolValue)
            default:
                return nil
            }
        default: return nil
            }
    }
    /// gives Int if self holds it. nil otherwise
    public var asInt:Int? {
        switch _value {
        case let o as NSNumber:
            switch String.fromCString(o.objCType)! {
            case "c", "C":
                return nil
            default:
                return Int(o.longLongValue)
            }
        default: return nil
            }
    }
    /// gives Double if self holds it. nil otherwise
    public var asDouble:Double? {
        switch _value {
        case let o as NSNumber:
            switch String.fromCString(o.objCType)! {
            case "c", "C":
                return nil
            default:
                return Double(o.doubleValue)
            }
        default: return nil
            }
    }
    // an alias to asDouble
    public var asNumber:Double? { return asDouble }
    /// gives String if self holds it. nil otherwise
    public var asString:String? {
        switch _value {
        case let o as NSString:
            return o as String
        default: return nil
            }
    }
    /// if self holds NSArray, gives a [JSON]
    /// with elements therein. nil otherwise
    public var asArray:[JSON]? {
        switch _value {
        case let o as NSArray:
            var result = [JSON]()
            for v:AnyObject in o { result.append(JSON(v)) }
            return result
        default:
            return nil
            }
    }
    /// if self holds NSDictionary, gives a [String:JSON]
    /// with elements therein. nil otherwise
    public var asDictionary:[String:JSON]? {
        switch _value {
        case let o as NSDictionary:
            var result = [String:JSON]()
            for (k:AnyObject, v:AnyObject) in o {
                result[k as String] = JSON(v)
            }
            return result
        default: return nil
            }
    }
    /// Yields date from string
    public var asDate:NSDate? {
        if let dateString = _value as? NSString {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            return dateFormatter.dateFromString(dateString)
            }
            return nil
    }
    /// gives the number of elements if an array or a dictionary.
    /// you can use this to check if you can iterate.
    public var length:Int {
        switch _value {
        case let o as NSArray: return o.count
        case let o as NSDictionary: return o.count
        default: return 0
            }
    }
}
extension JSON : SequenceType {
    public func generate()->GeneratorOf<(AnyObject,JSON)> {
        switch _value {
        case let o as NSArray:
            var i = -1
            return GeneratorOf<(AnyObject, JSON)> {
                if ++i == o.count { return nil }
                return (i, JSON(o[i]))
            }
        case let o as NSDictionary:
            var ks = o.allKeys!.reverse()
            return GeneratorOf<(AnyObject, JSON)> {
                if ks.isEmpty { return nil }
                let k = ks.removeLast() as String
                return (k, JSON(o.valueForKey(k)))
            }
        default:
            return GeneratorOf<(AnyObject, JSON)>{ nil }
        }
    }
    public func mutableCopyOfTheObject() -> AnyObject {
        return _value.mutableCopy()
    }
}
extension JSON : Printable {
    /// stringifies self.
    /// if pretty:true it pretty prints
    public func toString(pretty:Bool=false)->String {
        switch _value {
        case is NSError: return "\(_value)"
        case is NSNull: return "null"
        case let o as NSNumber:
            switch String.fromCString(o.objCType)! {
            case "c", "C":
                return o.boolValue.description
            case "q", "l", "i", "s":
                return o.longLongValue.description
            case "Q", "L", "I", "S":
                return o.unsignedLongLongValue.description
            default:
                switch o.doubleValue {
                case 0.0/0.0: return "0.0/0.0" // NaN
                case -1.0/0.0: return "-1.0/0.0" // -infinity
                case +1.0/0.0: return "+1.0/0.0" // infinity
                default:
                    return o.doubleValue.description
                }
            }
        case let o as NSString:
            return o.debugDescription
        default:
            let opts = pretty
                ? NSJSONWritingOptions.PrettyPrinted : nil
            let data = NSJSONSerialization.dataWithJSONObject(
                _value, options:opts, error:nil
            )
            return NSString(
                data:data, encoding:NSUTF8StringEncoding
            )
        }
    }
    public var description:String { return toString() }
}