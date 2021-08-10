//
//  Alert.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 10/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import MBProgressHUD
import SystemConfiguration

protocol Utilities {
}

class Alert: NSObject,MBProgressHUDDelegate {

    // function to set show alert
    class func showAlert( strMessage: NSString,onView : UIViewController) {
        if onView.navigationController != nil {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: Constants.kAppDisplayName as String, message: strMessage as String, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                onView.present(alertController, animated: true, completion: nil)
            }
         }
    }
    // function to set show alert with title

    class func showAlertWithTitle(strTitle : NSString  , strMessage : NSString , onView : UIViewController){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: strTitle as String, message: strMessage as String, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            onView.present(alertController, animated: true, completion: nil)
        }
    }
    class func showAlertWithOkHandler(strMessage:String ,onView:UIViewController, okBlock:@escaping ()->Void){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: Constants.kAppDisplayName as String, message: strMessage as String, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: { action in
                okBlock()
            }))
            onView.present(alertController, animated: true, completion: nil)
        }
    }
    // called method when show processing symbol
    class func showProgressHud(onView : UIView){
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: onView, animated: true)
        }
    }
    // called method when hide processing symbol
    class func hideProgressHud(onView : UIView){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: onView, animated: true)
        }
    }
}
