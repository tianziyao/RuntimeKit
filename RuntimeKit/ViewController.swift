//
//  ViewController.swift
//  RuntimeKit
//
//  Created by 田子瑶 on 2017/3/6.
//  Copyright © 2017年 田子瑶. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("--获取类名--\n")
//        print(RuntimeKit.fetchClassName(TestClass.self))
//        print("\n--获取成员变量--\n")
//        RuntimeKit.fetchIvarList(TestClass.self).map {
//            print("\($0)" + "\n")
//        }
//        print("--获取成员属性--\n")
//        RuntimeKit.fetchIvarPropertyList(TestClass.self).map {
//            print("\($0)" + "\n")
//        }
//        print("--获取实例方法--\n")
//        RuntimeKit.fetchMethodList(TestClass.self).map {
//            print("\($0)" + "\n")
//        }
//
//        print("--获取协议列表--\n")
//        RuntimeKit.fetchProtocolList(TestClass.self).map {
//            print("\($0)" + "\n")
//        }
//        
//        let testClass = TestClass()
//        
        
//        /*******方法交换*******/
//        let testClass = TestClass()
//        let firstMethod = #selector(TestClass.firsrMethod)
//        let secondMethod = #selector(TestClass.secondMethod)
//        RuntimeKit.methodSwap(TestClass.self, firstMethod: firstMethod, secondMethod: secondMethod)
//        testClass.performSelector(firstMethod)
//        testClass.performSelector(secondMethod)
//        
//        /*******动态添加方法*******/
//        let selector = #selector(AnotherClass.testClassAddMethod)
//        guard RuntimeKit.addMethod(AnotherClass.self, TestClass.self, selector) else { return }
//        testClass.performSelector(selector)
        
//        /*******动态添加属性*******/
//        let anotherClass = AnotherClass()
//        var key = "anotherClass"
//        RuntimeKit.setDynamicProperty(testClass, &key, "123", .OBJC_ASSOCIATION_ASSIGN)
//        let object = RuntimeKit.getDynamicProperty(testClass, key: &key)
//        print(object)
//        RuntimeKit.removeDynamicProperty(testClass)
//        print(object)
        
        button = UIButton()
        view.addSubview(button)
        button.setTitle("A", forState: .Normal)
        button.frame.size = CGSize(width: 100, height: 100)
        button.center = view.center
        button.layer.borderColor = UIColor.darkGrayColor().CGColor
        button.layer.borderWidth = 1
        button.acceptEventInterval = 2
        button.acceptEventTime = 0
        button.addTarget(self, action: #selector(self.buttonTouched), forControlEvents: .TouchUpInside)
    
    }
    
    func buttonTouched() {
        print(#function)
    }
    
    func testClassAddMethod() {
        print("this is a log")
    }
    
    func test2() {
        print("this is a log 2")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

