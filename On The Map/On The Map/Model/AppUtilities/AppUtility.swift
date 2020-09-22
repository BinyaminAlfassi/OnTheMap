//
//  AppUtility.swift
////  On The Map
////
////  Created by Binyamin Alfassi on 17/09/2020.
////  Copyright © 2020 Binyamin Alfassi. All rights reserved.
////
import Foundation
import UIKit

class AppUtilities {
        
    class func SetBarButtons(_ vc: UIViewController, addFunc: Selector, refreshFunc: Selector) {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: vc, action: refreshFunc)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addFunc)
        vc.navigationItem.rightBarButtonItems = [addButton, refreshButton]
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem()
        vc.navigationItem.leftBarButtonItem?.title = "LOGOUT"
    }
    
    class func verifyUrl(_ urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
