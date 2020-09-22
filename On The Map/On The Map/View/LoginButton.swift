//
//  LoginButton.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 17/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryDark
    }
    
}
