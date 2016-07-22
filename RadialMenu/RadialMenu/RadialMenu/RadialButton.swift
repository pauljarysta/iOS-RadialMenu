//
//  RadialButton.swift
//  RadialMenu
//
//  Created by Paul Jarysta on 21/07/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit

class RadialButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	var borderWidth: CGFloat? = 3
	var borderColor: CGColor? = UIColor.whiteColor().CGColor
	var backgroundBtnColor: UIColor? = UIColor.clearColor()
	var cornerRadius: CGFloat? = 50 / 2
	var x: CGFloat? = 0
	var y: CGFloat? = 0
	var width: CGFloat? = 50
	var height: CGFloat? = 50
	var frameBtn: CGRect? = CGRectMake(0, 0, 50, 50)
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initSetup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initSetup()
	}

	func config(borderWidth bWidth: CGFloat = 3,
	            borderColor: CGColor = UIColor.whiteColor().CGColor,
	            cornerRadius: CGFloat = 50 / 2,
	            backgroundColor: UIColor = UIColor.clearColor()) {
		
		self.layer.borderWidth = bWidth
		self.layer.borderColor = borderColor
		self.layer.cornerRadius = cornerRadius
		self.backgroundColor = backgroundColor
	}
	
	func initSetup() {
		
		if bounds == CGRectZero {
			self.frame = frameBtn!
		}
		print(borderWidth)
		self.layer.borderWidth = borderWidth!
		self.layer.borderColor = borderColor!
		self.layer.cornerRadius = cornerRadius!
		self.backgroundColor = backgroundBtnColor
	}

}
