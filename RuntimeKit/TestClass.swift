//
//  TestClass.swift
//  RuntimeKit
//
//  Created by 田子瑶 on 2017/3/6.
//  Copyright © 2017年 田子瑶. All rights reserved.
//

import UIKit

extension TestClass {
    
    var extensionProperty: String {
        return ""
    }
}

@objc protocol TestClassProtocol {
    var protocolProperty: String { get set }
    func testClassProtocolMethod()
}

extension TestClass: TestClassProtocol {
    
    var protocolProperty: String {
        set {
            self.protocolProperty += newValue
        }
        get {
            return self.protocolProperty
        }
    }
    func testClassProtocolMethod() {}
        
}

@objc public class TestClass: NSObject, NSCoding {
        
    public var publicArray: [String]?
    // 私有数组和字典默认不读取，如果要读取私有数组，需要加 dynamic
    private var privateArray: [String]?
    dynamic private var dynamicPrivateArray: [String]?
    private var privateDict: [[String]]?
    dynamic private var dynamicPrivateDict: [[String]]?
    private (set) var str: String?
    var object: NSObject?
    // 基本数据类型的可选类型不支持 dynamic
    dynamic var num: Int = 0
    var isOn: Bool?
    
    var computedProperty: String {
        return ""
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
    }
    
    override init() {
        super.init()
        
    }

    dynamic public class func classMethod(value: String) {

    }
    
    public func publicMethod() {
        
    }
    
    dynamic private func privateMethod() {
    
    }
    
    func firsrMethod() {
        print("A")
    }
    
    func secondMethod() {
        print("B")
    }
    

}

extension TestClass: NSCopying {
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        return ""
    }
}
