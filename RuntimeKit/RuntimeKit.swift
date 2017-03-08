//
//  RuntimeKit.swift
//  RuntimeKit
//
//  Created by 田子瑶 on 2017/3/6.
//  Copyright © 2017年 田子瑶. All rights reserved.
//

import UIKit

public class RuntimeKit: NSObject {
    
    // 获取类名
    public class func fetchClassName(cls: AnyClass!) -> String {
        let className = class_getName(cls)
        return String.init(UTF8String: className)!
    }
    
    // 获取成员变量列表
    public class func fetchIvarList(cls: AnyClass) -> [String : String] {
        var count: UInt32 = 0
        let ivarList = class_copyIvarList(cls, &count)
        var dicts: [String : String] = [String : String]()
        for i in 0 ..< count {
            let ivarName = ivar_getName(ivarList[Int(i)])
            let ivarType = ivar_getTypeEncoding(ivarList[Int(i)])
            dicts[String.init(UTF8String: ivarName)!] = String.init(UTF8String: ivarType)
        }
        free(ivarList)
        return dicts
    }
    
    // 获取成员属性列表
    public class func fetchIvarPropertyList(cls: AnyClass) -> [String] {
        var count: UInt32 = 0
        let propertyList = class_copyPropertyList(cls, &count)
        var array: [String] = [String]()
        for i in 0 ..< count {
            let propertyName = property_getName(propertyList[Int(i)])
            array.append(String(UTF8String: propertyName)!)
        }
        free(propertyList)
        return array
    }
    
    // 获取实例方法列表
    public class func fetchMethodList(cls: AnyClass) -> [String] {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(cls, &count)
        var array: [String] = [String]()
        for i in 0 ..< count {
            let method = methodList[Int(i)]
            let selector = method_getName(method)
            array.append(NSStringFromSelector(selector))
        }
        free(methodList)
        return array
    }
    
    // 获取协议列表
    public class func fetchProtocolList(cls: AnyClass) -> [String] {
        var count: UInt32 = 0
        let protocolList = class_copyProtocolList(cls, &count)
        var array: [String] = [String]()
        for i in 0 ..< count {
            let iprotocol = protocol_getName(protocolList[Int(i)])
            array.append(String.init(UTF8String: iprotocol)!)
        }
        return array
    }
    
    // 获取实例方法
    public class func fetchMethod(cls: AnyClass, methodName: String) -> Selector? {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(cls, &count)
        for i in 0 ..< count {
            let method = methodList[Int(i)]
            let selector = method_getName(method)
            if methodName == NSStringFromSelector(selector) {
                free(methodList)
                return selector
            }
        }
        free(methodList)
        return nil
    }
    
    public class func fetchIvar(cls: AnyClass, ivarName: String) -> Ivar? {
        var count: UInt32 = 0
        let ivarList = class_copyIvarList(cls, &count)
        for i in 0 ..< count {
            let ivar = ivar_getName(ivarList[Int(i)])
            if String(UTF8String: ivar) == ivarName {
                free(ivarList)
                return ivarList[Int(i)]
            }
        }
        free(ivarList)
        return nil
    }
    
    /*
     object: 需要传值的实例对象
     ivar: 对象的变量
     value: 变量的值
     */
    public func setIvar(object: AnyObject, ivar: Ivar, value: AnyObject!) {
        object_setIvar(object, ivar, value)
    }
    
    /* 添加实例方法
     - selectorClass: 方法所属的类
     - tagerClass: 要添加方法的类
     - selector: 要添加的方法 */
    public class func addMethod(selectorClass: AnyClass, _ tagerClass: AnyClass, _ selector: Selector) -> Bool {
        let instance = class_getInstanceMethod(selectorClass, selector)
        let implementation = method_getImplementation(instance)
        let types = method_getTypeEncoding(instance)
        let rusult = class_addMethod(tagerClass, selector, implementation, types)
        guard rusult else {
            print("添加方法失败")
            return false
        }
        guard class_respondsToSelector(tagerClass, selector) else {
            print("没有响应方法")
            return false
        }
        return rusult
    }

    // 方法交换
    public class func swapMethod(cls: AnyClass, original: Selector, swizzled: Selector) {
        let first = class_getInstanceMethod(cls, original)
        let second = class_getInstanceMethod(cls, swizzled)
        method_exchangeImplementations(first, second)
    }
    
    // 方法替换
    public class func replaceMethod(cls: AnyClass, original: Selector, swizzled: Selector) {
        let second = class_getInstanceMethod(cls, swizzled)
        let implementation = method_getImplementation(second)
        let types = method_getTypeEncoding(second)
        class_replaceMethod(cls, original, implementation, types)
    }

    /*
     object: 保存到哪个对象中
     key: 用什么属性保存传入的值
     value: 需保存值
     policy: 策略,strong,weak等
     OBJC_ASSOCIATION_ASSIGN,给关联对象指定弱引用,相当于@property(assign)或@property(unsafe_unretained)
     OBJC_ASSOCIATION_RETAIN_NONATOMIC,给关联对象指定非原子的强引用,相当于@property(nonatomic,strong)或@property(nonatomic,retain)
     OBJC_ASSOCIATION_COPY_NONATOMIC,给关联对象指定非原子的copy特性,相当于@property(nonatomic,copy)
     OBJC_ASSOCIATION_RETAIN,给关联对象指定原子强引用,相当于@property(atomic,strong)或@property(atomic,retain)
     OBJC_ASSOCIATION_COPY,给关联对象指定原子copy特性,相当于@property(atomic,copy)
     
     断开关联时使用传入nil值即可。
     */
    public class func setDynamicProperty(object: AnyObject!, _ key: UnsafePointer<Void>, _ value: AnyObject!, _ policy: objc_AssociationPolicy) {
        objc_setAssociatedObject(object, key, value, policy)
    }
    
    /*
     object: 从哪个对象中获取值
     key: 用什么属性获取值
     */
    public class func getDynamicProperty(object: AnyObject, key: UnsafePointer<Void>) -> AnyObject {
        return objc_getAssociatedObject(object, key)
    }
    
    /*
     不建议使用，会断开对象所有的关联属性，
     断开单个属性连接请使用 setDynamicProperty 传入 nil
     object: 要移除关联的对象
     */
    public class func removeDynamicProperty(object: AnyObject) {
        objc_removeAssociatedObjects(object)
    }
}

