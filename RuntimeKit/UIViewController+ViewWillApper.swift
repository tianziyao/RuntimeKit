//
//  UIViewController+ViewWillApper.swift
//  RuntimeKit
//
//  Created by 田子瑶 on 2017/3/8.
//  Copyright © 2017年 田子瑶. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public override static func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        guard self == UIViewController.self else { return }
        
        dispatch_once(&Static.token) {
            let original = #selector(UIViewController.viewWillAppear(_:))
            let swizzled = #selector(UIViewController.newViewWillAppear(_:))
            guard RuntimeKit.addMethod(self, self, swizzled) else {
                RuntimeKit.swapMethod(self, original: original, swizzled: swizzled)
                return
            }
            RuntimeKit.replaceMethod(self, original: original, swizzled: swizzled)
        }
    }
    
    func newViewWillAppear(animated: Bool) {
        self.newViewWillAppear(animated)
        print(#function)
    }
}

