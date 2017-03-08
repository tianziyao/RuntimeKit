//
//  UIButton+AcceptEventTime.swift
//  RuntimeKit
//
//  Created by 田子瑶 on 2017/3/8.
//  Copyright © 2017年 田子瑶. All rights reserved.
//

import Foundation
import UIKit

private var acceptEventTimeKey: String = "acceptEventTimeKey"
private var acceptEventIntervalKey: String = "acceptEventIntervalKey"

extension UIButton {
    
    var acceptEventTime: NSTimeInterval {
        set {
            RuntimeKit.setDynamicProperty(self, &acceptEventTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return RuntimeKit.getDynamicProperty(self, key: &acceptEventTimeKey) as! NSTimeInterval
        }
    }
    
    var acceptEventInterval: NSTimeInterval {
        set {
            RuntimeKit.setDynamicProperty(self, &acceptEventIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return RuntimeKit.getDynamicProperty(self, key: &acceptEventIntervalKey) as! NSTimeInterval
        }
    }
    
    public override static func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        guard self == UIButton.self else { return }
        
        dispatch_once(&Static.token) {
            let original = #selector(self.sendAction(_:to:forEvent:))
            let swizzled = #selector(self.tzySendAction(_:to:forEvent:))
            guard RuntimeKit.addMethod(self, self, swizzled) else {
                RuntimeKit.swapMethod(self, original: original, swizzled: swizzled)
                return
            }
            RuntimeKit.replaceMethod(self, original: original, swizzled: swizzled)
        }
    }
    
    func tzySendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        
        if NSDate().timeIntervalSince1970 - acceptEventTime < acceptEventInterval {
            return
        }
        if acceptEventInterval > 0 { //10
            acceptEventTime = NSDate().timeIntervalSince1970 //1000
        }
        tzySendAction(action, to: target, forEvent: event)
    }
}
