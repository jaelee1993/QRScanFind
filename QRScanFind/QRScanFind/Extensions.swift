//
//  Extensions.swift
//  QRScanFind
//
//  Created by Jae Lee on 8/25/21.
//

import Foundation
import UIKit

extension UIView {
    func constraintsToSafeArea(_ superView:UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor),
            ])
    }
    func constraintsToSuperView(_ superView:UIView, constant:CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -constant),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -constant),
            ])
    }
    
    func constraintsToSuperView(_ superView:UIView, topBottom:CGFloat = 0, leadingTrailing:CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: topBottom),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -topBottom),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leadingTrailing),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -leadingTrailing),
            ])
    }
    func constraintsToSuperView(_ superView:UIView, top:CGFloat = 0, bottom:CGFloat = 0, leading:CGFloat = 0, trailing:CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -bottom),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leading),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -trailing),
            ])
    }
}



extension UIViewController {
    func launchTimedModal(text:String, duration:Double, asTitle:Bool=false) -> UIAlertController {
        var alertController: UIAlertController
        if asTitle {
            alertController = UIAlertController(title: text, message: "", preferredStyle: .alert)
        } else {
            alertController = UIAlertController(title: "", message: text, preferredStyle: .alert)
        }
        
        self.present(alertController, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alertController.dismiss(animated: true, completion: nil)
        }
        return alertController
    }
    func launchTimedModal(text:String, duration:Double, completion:@escaping ()->()) -> UIAlertController {
        let alertController = UIAlertController(title: "", message: text, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alertController.dismiss(animated: true, completion: completion)
        }
        return alertController
    }
}
