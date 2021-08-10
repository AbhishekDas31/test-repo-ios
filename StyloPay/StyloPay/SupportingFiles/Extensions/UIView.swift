//
//  UIView.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 10/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyGradient() {
        let gradient = CAGradientLayer()
        let firstcolor = #colorLiteral(red: 0.7996706367, green: 0.2078832686, blue: 0.4001258612, alpha: 1)
        let secondcolor = #colorLiteral(red: 0.4489943981, green: 0.2486716509, blue: 0.8300958276, alpha: 1)
        gradient.colors = [firstcolor,secondcolor]   // your colors go here
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension UITextField {
    func replacingCaracter(in range: NSRange, with replacement: String) -> String {
        return (self.text! as NSString).replacingCharacters(in: range, with: replacement)
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
