//
//  RadialMenu.swift
//  RadialMenu
//
//  Created by Paul Jarysta on 21/07/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit
import AudioToolbox

protocol RadialMenuDelegate {
	func radialMenu(radialMenu: RadialMenu, selectedButton: UIButton)
	func radialMenuDidCancel(radialMenu: RadialMenu)
}

class RadialMenu: UIView {

	var delegate: RadialMenuDelegate?
	
	var radialMenuContainer: UIView?
	var anchorView: UIView?
	var firstButton: RadialButton = RadialButton()
	var secondButton: RadialButton = RadialButton()
	var thirdButton: RadialButton = RadialButton()
	
	var displayBackgroundView: Bool?
    var animationTime: TimeInterval?
	var actionView: UIView?

	var selectedButton: UIButton?
	var buttons: NSArray?
	var pointOfView: CGPoint?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		baseInit()
	}
	
	required override init(frame: CGRect) {
		super.init(frame: frame)
		baseInit()
	}
	
	func baseInit() {
        self.backgroundColor = UIColor.clear
		self.anchorView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
		self.anchorView!.layer.borderWidth = 3
        self.anchorView!.layer.borderColor = UIColor.white.cgColor
		self.anchorView!.layer.cornerRadius = self.anchorView!.bounds.size.width / 2
		self.anchorView!.alpha = 0.0
		self.addSubview(self.anchorView!)

		self.displayBackgroundView = true
		self.animationTime = 0.25
	}
	
	func configureWithButtons(buttons: NSArray, view: UIView, delegate: RadialMenuDelegate) {
        self.configureButtons(buttons: buttons)
        self.insertInView(view: view)
		self.configureGesture()
		self.delegate = delegate
	}
	
	func configureButtons(buttons: NSArray) {
		if buttons.count > 3 {
			print("Too many buttons in radial menu: ignoring the last \(buttons.count - 3)")
		}
		self.buttons = [buttons[0], buttons[1], buttons[2]]
		for i in 0 ..< self.buttons!.count {
			let button: UIButton = (buttons[i] as! UIButton)
			if i == 0 {
				self.firstButton.setTitle(button.titleLabel!.text, for: .normal)
                self.firstButton.setImage(button.imageView!.image, for: .normal)
				self.firstButton.backgroundColor = button.backgroundColor
				self.firstButton.layer.borderWidth = button.layer.borderWidth
				self.firstButton.layer.borderColor = button.layer.borderColor
				self.firstButton.layer.cornerRadius = button.layer.cornerRadius
				self.firstButton.tag = i
				self.addSubview(self.firstButton)
			}
			else if i == 1 {
				self.secondButton.setTitle(button.titleLabel!.text, for: .normal)
				self.secondButton.setImage(button.imageView!.image, for: .normal)
				self.secondButton.backgroundColor = button.backgroundColor
				self.secondButton.layer.borderWidth = button.layer.borderWidth
				self.secondButton.layer.borderColor = button.layer.borderColor
				self.secondButton.layer.cornerRadius = button.layer.cornerRadius
				self.secondButton.tag = i
				self.addSubview(self.secondButton)
			}
			else if i == 2 {
				self.thirdButton.setTitle(button.titleLabel!.text, for: .normal)
				self.thirdButton.setImage(button.imageView!.image, for: .normal)
				self.thirdButton.backgroundColor = button.backgroundColor
				self.thirdButton.layer.borderWidth = button.layer.borderWidth
				self.thirdButton.layer.borderColor = button.layer.borderColor
				self.thirdButton.layer.cornerRadius = button.layer.cornerRadius
				self.thirdButton.tag = i
				self.addSubview(self.thirdButton)
			}
		}
	}
	
	func insertInView(view: UIView) {
		self.radialMenuContainer = UIView()
        self.radialMenuContainer!.backgroundColor = UIColor.black.withAlphaComponent(0.7)
		self.radialMenuContainer!.alpha = 0.0
		view.addSubview(self.radialMenuContainer!)
		self.radialMenuContainer!.addSubview(self)
		
		let views: [String : AnyObject] = ["radialMenuContainer": self.radialMenuContainer!, "radialMenu": self]
		
		self.translatesAutoresizingMaskIntoConstraints = false
		self.radialMenuContainer!.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[radialMenuContainer]-0-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[radialMenuContainer]-0-|", options: [], metrics: nil, views: views))
        self.radialMenuContainer!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[radialMenu]-0-|", options: [], metrics: nil, views: views))
        self.radialMenuContainer!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[radialMenu]-0-|", options: [], metrics: nil, views: views))
		
	}
	
	func configureGesture() {
        let longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
		longPressGestureRecognizer.minimumPressDuration = 0.5
		self.radialMenuContainer!.superview!.addGestureRecognizer(longPressGestureRecognizer)
	}
	
    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
		if (self.actionView != nil) {
            self.pointOfView = gesture.location(in: self.actionView)
		}
        self.handleLongPress(gestureRecognizer: gesture, touchedPoint: gesture.location(in: self.radialMenuContainer!.superview))
	}
	
	func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer, touchedPoint: CGPoint) {
	
		if (UIGestureRecognizer.State.began == gestureRecognizer.state) {
			
            // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.hapticTapped(type: 6)
            
			self.anchorView!.center = touchedPoint
			self.firstButton.center = touchedPoint
			self.secondButton.center = touchedPoint
			self.thirdButton.center = touchedPoint
	
			if (!self.displayBackgroundView!) {
                self.radialMenuContainer!.backgroundColor = UIColor.clear
			}
	
            UIView.animate(withDuration: self.animationTime!, animations: {() -> Void in
				self.radialMenuContainer!.alpha = 1.0
				self.anchorView!.alpha = 1.0
			})

	
			let distance: CGFloat? = 90
			let anglesArray: [AnyObject] = self.anglesArrayWithTouchedPoint(touchedPoint: touchedPoint, distance: distance!)
			if anglesArray.count > 0 {
                self.moveButton(button: self.firstButton, fromPoint: touchedPoint, distance: distance!, angle: CGFloat(truncating: anglesArray[0] as! NSNumber), delay: 0.1)
			}
			if anglesArray.count > 1 {
                moveButton(button: self.secondButton, fromPoint: touchedPoint, distance: distance!, angle: CGFloat(truncating: anglesArray[1] as! NSNumber), delay: 0.15)
			}
			if anglesArray.count > 2 {
                self.moveButton(button: self.thirdButton, fromPoint: touchedPoint, distance: distance!, angle: CGFloat(truncating: anglesArray[2] as! NSNumber), delay: 0.2)
			}
		}

		if UIGestureRecognizer.State.ended == gestureRecognizer.state {
			if (self.selectedButton != nil) {
                self.delegate!.radialMenu(radialMenu: self, selectedButton: self.selectedButton!)
			}
			else {
                self.delegate!.radialMenuDidCancel(radialMenu: self)
			}
            UIView.animate(withDuration: self.animationTime!, animations: {() -> Void in
				if self.radialMenuContainer!.alpha > 0.0 {
					self.radialMenuContainer!.alpha = 0.0
				}
				self.anchorView!.alpha = 0.0
				self.firstButton.center = self.anchorView!.center
				self.firstButton.alpha = 0.0
				self.secondButton.center = self.anchorView!.center
				self.secondButton.alpha = 0.0
				self.thirdButton.center = self.anchorView!.center
				self.thirdButton.alpha = 0.0
			})
		}
		
        if self.touchPoint(point: touchedPoint, isInsideView: self.firstButton) {
			self.selectedButton = self.firstButton
			self.scaleView(view: self.firstButton, value: 1.5)
		} else {
			self.scaleView(view: self.firstButton, value: 1.0)
		}
		
		if self.touchPoint(point: touchedPoint, isInsideView: self.secondButton) {
			self.selectedButton = self.secondButton
			self.scaleView(view: self.secondButton, value: 1.5)
		} else {
			self.scaleView(view: self.secondButton, value: 1.0)
		}
		
		if self.touchPoint(point: touchedPoint, isInsideView: self.thirdButton) {
			self.selectedButton = self.thirdButton
            self.scaleView(view: self.thirdButton, value: 1.5)
		} else {
			self.scaleView(view: self.thirdButton, value: 1.0)
		}
		
		if !self.touchPoint(point: touchedPoint, isInsideView: self.firstButton) && !self.touchPoint(point: touchedPoint, isInsideView: self.secondButton) && !self.touchPoint(point: touchedPoint, isInsideView: self.thirdButton) {
			self.selectedButton = nil
		}
	}
    
    func hapticTapped(type i: Int = 0) {
        switch i {
            case 1:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            
            case 2:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            
            case 3:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            
            case 4:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            
            case 5:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            
            case 6:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            
            default:
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
    }
	

    func moveButton(button: UIButton, fromPoint point: CGPoint, distance: CGFloat, angle: CGFloat, delay: TimeInterval) {
		let x: Float = Float(distance) * cosf(Float(angle) / 180.0 * Float.pi)
		let y: Float = Float(distance) * sinf(Float(angle) / 180.0 * Float.pi)
        UIView.animate(withDuration: self.animationTime!, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: [], animations: {() -> Void in
			button.alpha = 1.0
            button.center = CGPoint(x: point.x + CGFloat(x), y: point.y + CGFloat(y))
			}, completion: { _ in })
	}
	
	func scaleView(view: UIView, value: CGFloat) {
        UIView.animate(withDuration: self.animationTime!, delay: 0.0, usingSpringWithDamping: 7, initialSpringVelocity: 5, options: [], animations: {() -> Void in
            view.transform = CGAffineTransform(scaleX: value, y: value)
			}, completion: { _ in })
	}
	
	func touchPoint(point: CGPoint, isInsideView view: UIView) -> Bool {
		return (point.x > view.center.x - view.frame.size.width / 2 && point.x < view.center.x + view.frame.size.width / 2) && (point.y > view.center.y - view.frame.size.height / 2 && point.y < view.center.y + view.frame.size.height / 2)
	}
	
	func anglesArrayWithTouchedPoint(touchedPoint: CGPoint, distance: CGFloat) -> [AnyObject] {
	
		var touched = touchedPoint
	
		if ((self.actionView) != nil) {
			touched = pointOfView!
		}
	
		var positionArray: [AnyObject] = [AnyObject]()
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
		let times: Int = self.buttons!.count
		let step: Int = 45
        positionArray = self.generateArrayFrom(from: 270, times: times, step: -step) as [AnyObject]
		
		if touched.x + distance > screenWidth {
			// Right
			positionArray = self.generateArrayFrom(from: 270, times: times, step: -step) as [AnyObject]
			if touched.y + distance > screenHeight {
				// Bottom right
				positionArray = self.generateArrayFrom(from: 270, times: times, step: -step) as [AnyObject]
			}
	
			if touched.y - distance < 60 {
				// Top right
				positionArray = self.generateArrayFrom(from: 180, times: times, step: -step) as [AnyObject]
			}

		}
	
		if touched.x - distance < 0 {
			// Left
			positionArray = self.generateArrayFrom(from: 0, times: times, step: -step) as [AnyObject]
			if touched.y + distance > screenHeight {
				// Bottom left
				positionArray = self.generateArrayFrom(from: 0, times: times, step: -step) as [AnyObject]
			}
			if touched.y - distance < 60 {
				// Top left
				positionArray = self.generateArrayFrom(from: 90, times: times, step: -step) as [AnyObject]
			}
		}
	
		if touched.y - distance < 60 {
			// Top
			positionArray = self.generateArrayFrom(from: 180, times: times, step: -step) as [AnyObject]
			if touched.x + distance > screenWidth {
				// Top right
				positionArray = self.generateArrayFrom(from: 180, times: times, step: -step) as [AnyObject]
			}
			if touched.x - distance < 0 {
				// Top left
				positionArray = self.generateArrayFrom(from: 90, times: times, step: -step) as [AnyObject]
			}
		}
		
		if touched.y + distance > screenHeight {
			// Bottom
			positionArray = self.generateArrayFrom(from: 270, times: times, step: -step) as [AnyObject]
			if touched.x + distance > screenWidth {
				// Bottom right
				positionArray = self.generateArrayFrom(from: 270, times: times, step: -step) as [AnyObject]
			}
			if touched.x - distance < 0 {
				// Bottom left
				positionArray = self.generateArrayFrom(from: 0, times: times, step: -step) as [AnyObject]
			}
		}
	
	return positionArray;
}

	func generateArrayFrom(from: Int, times: Int, step: Int) -> NSArray {
		var array: [AnyObject] = [AnyObject]()
		if step > 0 {
            var i: Int = from
			while array.count < times {
                array.append(i as AnyObject)
				i += step
			}
		} else {
			var i = from
			while array.count < times {
                array.append(i as AnyObject)
				i += step
			}
		}
        return array as NSArray
	}
}
