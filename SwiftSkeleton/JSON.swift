//
//  QJSON.swift
//  AccessControl
//
//  Created by Jameson Quave on 7/25/14.
//  Copyright (c) 2014 JQ Software. All rights reserved.
//

import Foundation

func parseJSON(data: NSData) -> JSONVal {
    return JSON(data).parse()
}

func parseJSON(str: String) -> JSONVal {
    return JSON(str).parse()
}

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
    
    public var json = ""
    public var data: NSData
    
    init(_ json: String) {
        self.json = json
        self.data = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }
    
    init(_ data: NSData) {
        self.json = ""
        self.data = data
        //self.data = self.json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }

    public func parse() -> JSONVal {
        var err: NSError? = nil
        var val = JSONVal(NSJSONSerialization.JSONObjectWithData(self.data, options: nil, error: &err))
        
        return val
    }
    
    
    public class func encodeAsJSON(data: AnyObject!) -> String? {
        var json = ""
        
        if let rootObjectArr = data as? [AnyObject] {
            // Array
            json = "\(json)["
            for embeddedObject: AnyObject in rootObjectArr {
                var encodedEmbeddedObject = encodeAsJSON(embeddedObject)
                if encodedEmbeddedObject? != nil {
                    json = "\(json)\(encodedEmbeddedObject!),"
                }
                else {
                    println("Error creating JSON")
                    return nil
                }
            }
            json = "\(json)]"
        }
        else if let rootObjectStr = data as? String {
            // This is a string, just return it
            return escape(rootObjectStr)
        }
        else if let rootObjectDictStrStr = data as? Dictionary<String, String> {
            json = "\(json){"
            var numKeys = rootObjectDictStrStr.count
            var keyIndex = 0
            for (key,value) in rootObjectDictStrStr {
                
                // This could be a number
                
                if(keyIndex==(numKeys-1)) {
                    json = json.stringByAppendingString("\(escape(key)):\(escape(value))")
                }
                else {
                    json = json.stringByAppendingString("\(escape(key)):\(escape(value)),")
                }
                keyIndex = keyIndex + 1
            }
            json = "\(json)}"
        }
        else {
            println("Failed to write JSON object")
            return nil
        }
        
        return json
    }
    
    class func escape(str: String) -> String {
        var newStr = str.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        // Replace already escaped quotes with non-escaped quotes
        newStr = newStr.stringByReplacingOccurrencesOfString("\\\"", withString: "\"")
        // Escape all non-escaped quotes
        newStr = newStr.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
        return "\"\(newStr)\""
    }
    
    
}

//  SwiftyJSON.swift
//
//  Copyright (c) 2014年 Ruoyu Fu, Denis Lebedev.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation


enum JSONValue {
    
    
    case JNumber(NSNumber)
    case JString(String)
    case JBool(Bool)
    case JNull
    case JArray(Array<JSONValue>)
    case JObject(Dictionary<String,JSONValue>)
    case JInvalid(NSError)
    
    var string: String? {
        switch self {
        case .JString(let value):
            return value
        default:
            return nil
            }
    }
    
    var url: NSURL? {
        switch self {
        case .JString(let value):
            return NSURL(string: value)
        default:
            return nil
            }
    }
    var number: NSNumber? {
        switch self {
        case .JNumber(let value):
            return value
        default:
            return nil
            }
    }
    
    var double: Double? {
        switch self {
        case .JNumber(let value):
            return value.doubleValue
        case .JString(let value):
            return (value as NSString).doubleValue
        default:
            return nil
            }
    }
    
    var integer: Int? {
        switch self {
        case .JBool(let value):
            return Int(value)
        case .JNumber(let value):
            return value.integerValue
        case .JString(let value):
            return (value as NSString).integerValue
        default:
            return nil
            }
    }
    
    var bool: Bool? {
        switch self {
        case .JBool(let value):
            return value
        case .JNumber(let value):
            return value.boolValue
        case .JString(let value):
            return (value as NSString).boolValue
        default:
            return nil
            }
    }
    
    var array: Array<JSONValue>? {
        switch self {
        case .JArray(let value):
            return value
        default:
            return nil
            }
    }
    
    var object: Dictionary<String, JSONValue>? {
        switch self {
        case .JObject(let value):
            return value
        default:
            return nil
            }
    }
    
    var first: JSONValue? {
        switch self {
        case .JArray(let jsonArray) where jsonArray.count > 0:
            return jsonArray[0]
        case .JObject(let jsonDictionary) where jsonDictionary.count > 0 :
            let (_, value) = jsonDictionary[jsonDictionary.startIndex]
            return value
        default:
            return nil
            }
    }
    
    var last: JSONValue? {
        switch self {
        case .JArray(let jsonArray) where jsonArray.count > 0:
            return jsonArray[jsonArray.count-1]
        case .JObject(let jsonDictionary) where jsonDictionary.count > 0 :
            let (_, value) = jsonDictionary[jsonDictionary.endIndex]
            return value
        default:
            return nil
            }
    }
    
    init (_ data: NSData!){
        if let value = data{
            var error:NSError? = nil
            if let jsonObject : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) {
                self = JSONValue(jsonObject)
            }else{
                self = JSONValue.JInvalid(NSError(domain: "JSONErrorDomain", code: 1001, userInfo: [NSLocalizedDescriptionKey:"JSON Parser Error: Invalid Raw JSON Data"]))
            }
        }else{
            self = JSONValue.JInvalid(NSError(domain: "JSONErrorDomain", code: 1000, userInfo: [NSLocalizedDescriptionKey:"JSON Init Error: Invalid Value Passed In init()"]))
        }
        
    }
    
    init (_ rawObject: AnyObject) {
        switch rawObject {
        case let value as NSNumber:
            if String.fromCString(value.objCType) == "c" {
                self = .JBool(value.boolValue)
                return
            }
            self = .JNumber(value)
        case let value as NSString:
            self = .JString(value)
        case let value as NSNull:
            self = .JNull
        case let value as NSArray:
            var jsonValues = [JSONValue]()
            for possibleJsonValue : AnyObject in value {
                let jsonValue = JSONValue(possibleJsonValue)
                if  jsonValue {
                    jsonValues.append(jsonValue)
                }
            }
            self = .JArray(jsonValues)
        case let value as NSDictionary:
            var jsonObject = Dictionary<String, JSONValue>()
            for (possibleJsonKey : AnyObject, possibleJsonValue : AnyObject) in value {
                if let key = possibleJsonKey as? NSString {
                    let jsonValue = JSONValue(possibleJsonValue)
                    if jsonValue {
                        jsonObject[key] = jsonValue
                    }
                }
            }
            self = .JObject(jsonObject)
        default:
            self = .JInvalid(NSError(domain: "JSONErrorDomain", code: 1000, userInfo: [NSLocalizedDescriptionKey:"JSON Init Error: Invalid Value Passed In init()"]))
        }
    }
    
    subscript(index: Int) -> JSONValue {
        get {
            switch self {
            case .JArray(let jsonArray) where jsonArray.count > index:
                return jsonArray[index]
            case .JInvalid(let error):
                if let userInfo = error.userInfo{
                    if let breadcrumb = userInfo["JSONErrorBreadCrumbKey"] as? NSString{
                        let newBreadCrumb = (breadcrumb as String) + "/\(index)"
                        let newUserInfo = [NSLocalizedDescriptionKey: "JSON Keypath Error: Incorrect Keypath \"\(newBreadCrumb)\"",
                            "JSONErrorBreadCrumbKey": newBreadCrumb]
                        return JSONValue.JInvalid(NSError(domain: "JSONErrorDomain", code: 1002, userInfo: newUserInfo))
                    }
                }
                return self
            default:
                let breadcrumb = "\(index)"
                let newUserInfo = [NSLocalizedDescriptionKey: "JSON Keypath Error: Incorrect Keypath \"\(breadcrumb)\"",
                    "JSONErrorBreadCrumbKey": breadcrumb]
                return JSONValue.JInvalid(NSError(domain: "JSONErrorDomain", code: 1002, userInfo: newUserInfo))
            }
        }
    }
    
    subscript(key: String) -> JSONValue {
        get {
            switch self {
            case .JObject(let jsonDictionary):
                if let value = jsonDictionary[key] {
                    return value
                }else {
                    let breadcrumb = "\(key)"
                    let newUserInfo = [NSLocalizedDescriptionKey: "JSON Keypath Error: Incorrect Keypath \"\(breadcrumb)\"",
                        "JSONErrorBreadCrumbKey": breadcrumb]
                    return JSONValue.JInvalid(NSError(domain: "JSONErrorDomain", code: 1002, userInfo: newUserInfo))
                }
            case .JInvalid(let error):
                if let userInfo = error.userInfo{
                    if let breadcrumb = userInfo["JSONErrorBreadCrumbKey"] as? NSString{
                        let newBreadCrumb = (breadcrumb as String) + "/\(key)"
                        let newUserInfo = [NSLocalizedDescriptionKey: "JSON Keypath Error: Incorrect Keypath \"\(newBreadCrumb)\"",
                            "JSONErrorBreadCrumbKey": newBreadCrumb]
                        return JSONValue.JInvalid(NSError(domain: "JSONErrorDomain", code: 1002, userInfo: newUserInfo))
                    }
                }
                return self
            default:
                let breadcrumb = "/\(key)"
                let newUserInfo = [NSLocalizedDescriptionKey: "JSON Keypath Error: Incorrect Keypath \"\(breadcrumb)\"",
                    "JSONErrorBreadCrumbKey": breadcrumb]
                return JSONValue.JInvalid(NSError(domain: "JSONErrorDomain", code: 1002, userInfo: newUserInfo))
            }
        }
    }
}

extension JSONValue: Printable {
    var description: String {
        switch self {
        case .JInvalid(let error):
            return error.localizedDescription
        default:
            return _printableString("")
            }
    }
    
    var rawJSONString: String {
        switch self {
        case .JNumber(let value):
            return "\(value)"
        case .JBool(let value):
            return "\(value)"
        case .JString(let value):
            let jsonAbleString = value.stringByReplacingOccurrencesOfString("\"", withString: "\\\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
            return "\"\(jsonAbleString)\""
        case .JNull:
            return "null"
        case .JArray(let array):
            var arrayString = ""
            for (index, value) in enumerate(array) {
                if index != array.count - 1 {
                    arrayString += "\(value.rawJSONString),"
                }else{
                    arrayString += "\(value.rawJSONString)"
                }
            }
            return "[\(arrayString)]"
        case .JObject(let object):
            var objectString = ""
            var (index, count) = (0, object.count)
            for (key, value) in object {
                if index != count - 1 {
                    objectString += "\"\(key)\":\(value.rawJSONString),"
                } else {
                    objectString += "\"\(key)\":\(value.rawJSONString)"
                }
                index += 1
            }
            return "{\(objectString)}"
        case .JInvalid:
            return "INVALID_JSON_VALUE"
            }
    }
    
    func _printableString(indent: String) -> String {
        switch self {
        case .JObject(let object):
            var objectString = "{\n"
            var index = 0
            for (key, value) in object {
                let valueString = value._printableString(indent + "  ")
                if index != object.count - 1 {
                    objectString += "\(indent)  \"\(key)\":\(valueString),\n"
                } else {
                    objectString += "\(indent)  \"\(key)\":\(valueString)\n"
                }
                index += 1
            }
            objectString += "\(indent)}"
            return objectString
        case .JArray(let array):
            var arrayString = "[\n"
            for (index, value) in enumerate(array) {
                let valueString = value._printableString(indent + "  ")
                if index != array.count - 1 {
                    arrayString += "\(indent)  \(valueString),\n"
                }else{
                    arrayString += "\(indent)  \(valueString)\n"
                }
            }
            arrayString += "\(indent)]"
            return arrayString
        default:
            return rawJSONString
        }
    }
}

extension JSONValue: BooleanType {
    var boolValue: Bool {
        switch self {
        case .JInvalid:
            return false
        default:
            return true
            }
    }
}

extension JSONValue : Equatable {
    
}

func ==(lhs: JSONValue, rhs: JSONValue) -> Bool {
    switch lhs {
    case .JNumber(let lvalue):
        switch rhs {
        case .JNumber(let rvalue):
            return rvalue == lvalue
        default:
            return false
        }
    case .JString(let lvalue):
        switch rhs {
        case .JString(let rvalue):
            return rvalue == lvalue
        default:
            return false
        }
    case .JBool(let lvalue):
        switch rhs {
        case .JBool(let rvalue):
            return rvalue == lvalue
        default:
            return false
        }
    case .JNull:
        switch rhs {
        case .JNull:
            return true
        default:
            return false
        }
    case .JArray(let lvalue):
        switch rhs {
        case .JArray(let rvalue):
            return rvalue == lvalue
        default:
            return false
        }
    case .JObject(let lvalue):
        switch rhs {
        case .JObject(let rvalue):
            return rvalue == lvalue
        default:
            return false
        }
    default:
        return false
    }
}
