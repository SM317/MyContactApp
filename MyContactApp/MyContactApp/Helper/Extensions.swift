//
//  Extensions.swift
//  MyContactApp
//
//  Created by SourabhMehta on 21/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let scanner = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0;
        self.layer.borderColor = UIColor.white.cgColor
    }
}

extension UIView {
    func rotate360Degrees(_ duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        DispatchQueue.main.async {
            let kAnimationKey = "rotate360Degrees"
            if self.layer.animation(forKey: "rotate360Degrees") == nil {
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = 0.0
                rotateAnimation.toValue = CGFloat(-Double.pi * 2.0)
                rotateAnimation.duration = duration
                rotateAnimation.repeatCount = Float.infinity
                self.layer.add(rotateAnimation, forKey: kAnimationKey)
            }
        }
    }
    
    func stop360Rotation() {
        DispatchQueue.main.async {
            let kAnimationKey = "rotate360Degrees"
            if let _ = self.layer.animation(forKey: kAnimationKey) {
                self.layer.removeAnimation(forKey: kAnimationKey)
            }
            
        }
        
    }
}


extension Data {
    
    mutating func append(_ string: String) {
        
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
