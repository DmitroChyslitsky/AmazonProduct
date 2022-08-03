//
//  UIImageView+Ext.swift
//  Finiite
//
//  Created by Dmytro on 2/23/21.
//  Copyright © 2021 Dmytro. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(url: String, placeHolder: UIImage? = nil) {
         let url = url.contains("http") ? URL(string: url) : URL(string: url)
        self.kf.setImage(with: url)
    }
}
