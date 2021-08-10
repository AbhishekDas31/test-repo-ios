//
//  Global.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 10/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import MBProgressHUD

/// Just use //MARK: , //TODO: or //FIXME: instead of #pragma

@objc public protocol UICollectionViewButtonDelegate {
    /**
     Returns the button and cell reference
     */
    @objc optional func didSelect(_ sender: Any, ofCell cell: UICollectionViewCell)
    @objc optional func didSelect(_ sender: Any, ofHeader header: UICollectionReusableView)
}

@objc public protocol UITableViewButtonDelegate: class {
    /**
     Returns the button and cell reference
     */
    @objc optional func didSelect(_ sender: Any, ofCell cell: UITableViewCell)
    @objc optional func didSelect(_ sender: Any, ofHeader header: UITableViewHeaderFooterView)
}

public protocol CompletionDelegate: class {
    /**
     Returns completion with values
     */
    func didCompletion(with value: Any?)
}

@objc public protocol PageUpdateDelegate: class {
    
    @objc optional func didScrollTop()
    func didRefreshPage()
}

open class Global : NSObject {
    
    open class func stringifyJson(_ value: Any, prettyPrinted: Bool = false) -> NSString {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : .prettyPrinted
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string
                }
            }
        }
        return ""
    }

    
    /***********************************************************************************************/
    //MARK:- Globle Alert
    /***********************************************************************************************/
    open class func showAlert(withMessage message: String, sender: UIViewController? = UIApplication.topViewController(), buttonTitle: String? = "OK") {
        
        let alert = UIAlertController(title: Constants.kAppDisplayName, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler:nil))
        sender?.present(alert, animated: true, completion: nil)
    }

    open class func handleError(withMessage message: String, sender: UIViewController? = UIApplication.topViewController(), buttonTitle: String? = "OK", okBlock:@escaping ()->Void)
    {
        DispatchQueue.main.async {
            if let view = sender?.view
            {
                Alert.hideProgressHud(onView: view)
            }
            
            let alert = UIAlertController(title: Constants.kAppDisplayName, message: Constants.errorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default,handler: { action in
                okBlock()
            }))
            sender?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    public class func showAlertWithTwoHandler(strMessage:String,strActionOne:String, strActionTwo:String ,sender: UIViewController? = UIApplication.topViewController(), okBlock:@escaping ()->Void, cancelBlock:@escaping () ->Void){
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: Constants.kAppDisplayName as String, message: strMessage as String, preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: strActionOne, style: UIAlertAction.Style.default,handler: { action in
                okBlock()
            }))
            
            alertController.addAction(UIAlertAction(title: strActionTwo, style: UIAlertAction.Style.default,handler: { action in
                cancelBlock()
            }))
            
            sender?.present(alertController, animated: true, completion: nil)
        }
    }
    
    public class func showAlert(withMessage message: String, sender: UIViewController? = UIApplication.topViewController(), setTwoButton: Bool? = false , setFirstButtonTitle: String? = "OK" , setSecondButtonTitle: String? = "No" , handler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: Constants.kAppDisplayName, message: message, preferredStyle: .alert)
        
        if (setTwoButton == true) {
            alert.addAction(UIAlertAction(title: setSecondButtonTitle, style: .default, handler:nil))
        }
        alert.addAction(UIAlertAction(title: setFirstButtonTitle, style: .default, handler:{ (action) in
            handler!(action)
        }))
        sender?.present(alert, animated: true, completion: nil)
    }
    
    
    /*************************************************************/
    //MARK:- NSURL From String
    /*************************************************************/
    open class func NSURLFromString(_ aURLString:String!) -> URL {
        var returnValue:URL!;
        if let url = aURLString {
            let trimmedURLString:String! = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            returnValue = URL(string:trimmedURLString)
        }
        return returnValue;
    }
    
    
    /*************************************************************/
    //MARK:- Get NSDate From String and convert formate accordingly
    /*************************************************************/
    open class func getNSDateFromString(_ theDate:String, formate:String, convertFormate:String) -> String {
        
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: theDate)
        dateFormatter.dateFormat = convertFormate
        let newDateString = dateFormatter.string(from: date!)
        
        return Global.getVal(newDateString as AnyObject?) as? String ?? ""
    }
    
    /*************************************************************/
    //MARK:- App Set UserDefaults Values
    /*************************************************************/
    open class func setAppUserDefaultsValues(_ value:Any, key:String) {
        Constants.kUserDefaults.set(value, forKey: key)
        Constants.kUserDefaults.synchronize()
    }
    
    /*************************************************************/
    //MARK:- Get App UserDefaults Values
    /*************************************************************/
    open class func getAppUserDefaults(_ key:String) -> String {
        Constants.kUserDefaults.synchronize()
        return getVal(Constants.kUserDefaults.object(forKey: key) as AnyObject?) as! String
    }
    
    
    /*************************************************************/
    //MARK:- App NSNull or nil clear
    /*************************************************************/
    open class func getVal(_ param:AnyObject!) -> AnyObject {
        
        //printDebug("getVal = \(param)")
        
        if param == nil {
            return "" as AnyObject
        }
        else if param is NSNull {
            return "" as AnyObject
        }
            /*else if param is NSNumber {
             return "\(param)"
             }*/
        else {
            return param
        }
    }
    
    //MARK:- Get Integer Value
    
    open class func getDouble(for value: Any) -> Double {
        
        if let val = value as? Double {
            return val
        } else if let val = value as? String {
            return Double(val) ?? 0.0
        } else if let val = value as? Int {
            return Double(val)
        } else {
            return value as? Double ?? 0.0
        }
    }
    
    open class func getFloat(for value: Any) -> Float {
        
        if let val = value as? Float {
            return val
        } else if let val = value as? String {
            return Float(val) ?? 0.0
        } else if let val = value as? Int {
            return Float(val)
        } else {
            return value as? Float ?? 0.0
        }
    }
    open class func getStringFromAnyValue(for value: Any) -> String {
        
        if let val = value as? Double {
            return "\(val)"
        } else if let val = value as? String {
            return val
        } else if let val = value as? Int {
            return "\(val)"
        } else if let val = value as? Float {
            return "\(val)"
        }else {
            return "\(value)"
        }
    }
    
    open class func getInt(for value: Any) -> Int {
        
        if let val = value as? Int {
            return val
        } else if let val = value as? Double {
            return Int(val)
        } else if let val = value as? String {
            return Int(val) ?? 0
        } else if let val = value as? Bool {
            return Int(NSNumber(value: val)) 
        } else if let val = value as? NSNumber {
            return Int(val)
        }else {
            return value as? Int ?? 0
        }
    }
    
 
    open class func getStringValue(for value: Any) -> String {
        
        if let val = value as? Int {
            return "\(val)"
        } else if let val = value as? Double {
            return "\(val)"
        } else if let val = value as? String {
            return "\(val)"
        } else if let val = value as? Bool {
            return "\(val)"
        } else {
            return value as? String ?? ""
        }
    }
    
    /*************************************************************/
    //MARK:- Dictionary Removing Nulls or nil Values
    /*************************************************************/
    
    open class func dictionaryRemovingNulls( aDictionary param:NSDictionary) -> NSMutableDictionary{
        let rawData:NSDictionary = param as NSDictionary
        let mutableRawData:NSMutableDictionary = NSMutableDictionary(dictionary: rawData)
        for key in rawData.allKeys(for: NSNull()) {
            mutableRawData.setValue("", forKey: key as! String)
        }
        return mutableRawData
    }
    /*************************************************************/
    //MARK:- Dictionary Change NSNumber to String
    /*************************************************************/
    
    open class func stringifyDictionary(aDictionary param:NSDictionary) -> NSMutableDictionary {
        
        let rawData:NSDictionary = dictionaryRemovingNulls(aDictionary: param)
        let mutableRawData:NSMutableDictionary = NSMutableDictionary(dictionary: rawData)
        for key in rawData.allKeys {
            let value: AnyObject? = rawData.value(forKey: key as! String) as AnyObject?
            if (value!.isKind(of: NSNumber.self)) {
                let numberValue:NSNumber = rawData.value(forKey: key as! String) as! NSNumber
                mutableRawData.setValue(numberValue.stringValue, forKey: key as! String)
            }
        }
        return mutableRawData
    }
    
    
    open class func setButtonEdgeInsets(_ button: UIButton) {
        
        // raise the image and push it right to center it
        button.imageEdgeInsets = UIEdgeInsets(top: -((button.frame.size.height) - (button.imageView?.frame.size.height)! + 5.0 ), left: 0.0, bottom: 0.0,  right: -(button.titleLabel?.frame.size.width)!);
        
        // lower the text and push it left to center it
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -(button.imageView?.frame.size.width)!, bottom: -((button.frame.size.height) - (button.titleLabel?.frame.size.height)!),right: 0.0);
    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
