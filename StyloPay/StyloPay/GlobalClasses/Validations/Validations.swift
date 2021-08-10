//
//  Validations.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 14/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class Validation: NSObject{
    public class func isValid(email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let range = email.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    public class func isValidPassword(password: String) -> Bool{
        let regex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,21}$"
        let range = password.range(of: regex, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    public class func isBlank(_ object: Any) -> Bool{
        if object is UITextField{
            let text = (object as! UITextField).text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if text.isEmpty {
                return true
            }
        }
        else if object is UITextView {
            let text = (object as! UITextView).text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if text.isEmpty {
                return true
            }
        }
        else if object is String {
            
            let text = (object as! String).trimmingCharacters(in: .whitespacesAndNewlines)
            if text.isEmpty {
                return true
            }
        }
        return false
    }

    public class func isBlankIssueDate(_ object: String) -> Bool{
       if object == "FIN" || object == "Passport"
       {
        return true
       }
        else if object == "NRIC" || object == "GOVERNMENT ID" || object == "Driving Licence"
        {
            return false
        }

        return true
    }

    public class func isBlankExpiryDate(_ object: String) -> Bool{
       if object == "Passport"
       {
        return true
       }
        else if object == "NRIC" || object == "GOVERNMENT ID" || object == "FIN"  || object == "Driving Licence"
        {
            return false
        }

        return true
    }
}
