//
//  UITextField+image.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 5/28/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

extension UITextField {
    
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        mainView.backgroundColor = .clear
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        view.layer.borderWidth = 0
        mainView.addSubview(view)
//
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10.0, y: 4.0, width: 24.0, height: 24.0)
//        view.addSubview(imageView)
//
        mainView.addSubview(imageView)
        
//        let seperatorView = UIView()
//        seperatorView.backgroundColor = colorSeparator
//        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
//            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 30)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
//            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 30)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
//        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = 0.0
        self.layer.cornerRadius = 5
    }
    
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
