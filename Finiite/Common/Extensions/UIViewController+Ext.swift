//
//  UIViewController+Ext.swift
//  Finiite
//
//  Created by Dmytro on 2/23/21.
//  Copyright © 2021 Dmytro. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    public func showProgress() {
        DispatchQueue.main.async {
            let activityData = ActivityData(size: nil, message: nil, type: .circleStrokeSpin, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        }
        
    }
    
    public func hideProgress() {
         DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
}
