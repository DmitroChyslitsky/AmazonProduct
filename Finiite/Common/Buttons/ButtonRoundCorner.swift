//
//  ButtonRoundCorner.swift
//  Finiite
//
//  Created by Dmytro on 2/20/21.
//


import Foundation
import UIKit

@IBDesignable
class ButtonRoundCorner: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var cornerViewRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerViewRadius
            layer.masksToBounds = cornerViewRadius > 0
        }
    }
    @IBInspectable var borderViewWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderViewWidth
        }
    }
    @IBInspectable var borderViewColor: UIColor? {
        didSet {
            layer.borderColor = borderViewColor?.cgColor
        }
    }
}
