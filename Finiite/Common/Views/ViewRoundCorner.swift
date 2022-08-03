//
//  RoundCornerView.swift
//  Finiite
//
//  Created by Dmytro on 2/20/21.
//


import UIKit
@IBDesignable
class RoundCornerView: UIView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.clipsToBounds = true
    }
    
    @IBInspectable var borderViewWidth: CGFloat = 0{
        didSet {
            layer.borderWidth = borderViewWidth
        }
    }
    
    @IBInspectable var borderViewColor : UIColor? {
        
        didSet {
            layer.borderColor = borderViewColor?.cgColor
        }
    }
    
    @IBInspectable var cornerViewRadius : CGFloat = 0 {
        
        didSet {
            layer.cornerRadius = cornerViewRadius
            layer.masksToBounds = cornerViewRadius > 0
        }
    }
}
