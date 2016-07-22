//
//  ViewController.swift
//  RadialMenu
//
//  Created by Paul Jarysta on 21/07/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RadialMenuDelegate {

	@IBOutlet weak var pressView: UIToolbar!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let radialMenu: RadialMenu = RadialMenu()
		
		let b1: RadialButton = RadialButton(frame: CGRectMake(0, 0, 50, 50))
		b1.config(borderWidth: 2, borderColor: UIColor.redColor().CGColor)
		b1.setTitle("1", forState: .Normal)
		radialMenu.firstButton = b1
	
		let b2: RadialButton = RadialButton(frame: CGRectMake(0, 0, 50, 50))
		b2.config(borderWidth: 2)
		b2.setTitle("2", forState: .Normal)
		radialMenu.secondButton = b2

		let b3: RadialButton = RadialButton(frame: CGRectMake(0, 0, 50, 50))
		b3.config(borderWidth: 2, borderColor: UIColor.blueColor().CGColor)
		b3.setTitle("3", forState: .Normal)
		radialMenu.thirdButton = b3

		// Configuring radial menu with buttons
		radialMenu.configureWithButtons([b1, b2, b3], view: self.view!, delegate: self)
		
		// Display or not the fade vuew on the background
		radialMenu.displayBackgroundView = true
		
		// Animations time
		radialMenu.animationTime = 0.25
		
		// The color of the fade view on the background. Default is black with alpha 0.7
		radialMenu.radialMenuContainer!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)

		/*
		The action region of the menu: the region in which the menu is active and from which it cinfigure its position.
		Default is the view passed in the constructor.
		In this case the action view is the view of the controller, in order to have a nice behavior on the whole screen.
		*/
		// radialMenu.actionView = self.pressView
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func radialMenu(radialMenu: RadialMenu, selectedButton: UIButton) {
		
		if selectedButton.tag == 0 {
			doActionButton1()
		} else if selectedButton.tag == 1 {
			doActionButton2()
		} else if selectedButton.tag == 2 {
			doActionButton3()
		}
		
		let alert: UIAlertController = UIAlertController(title: "Button selected", message: "Button \(selectedButton.tag) selected", preferredStyle: .Alert)
		
		let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) -> Void in
			
		})
		alert.addAction(okAction)
		self.presentViewController(alert, animated: true, completion: { _ in })
	}
	
	func radialMenuDidCancel(radialMenu: RadialMenu) {
		print("Canceled")
	}

	func doActionButton1() {
		// Do something
	}
	
	func doActionButton2() {
		// Do something
	}
	
	func doActionButton3() {
		// Do something
	}

}

