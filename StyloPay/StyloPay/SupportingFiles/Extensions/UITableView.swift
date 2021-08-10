//
//  UITableView.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 13/08/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    // Export pdf from UITableView and save pdf in drectory and return pdf file path
    func exportAsPdfFromTable() -> NSMutableData{
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x:originalBounds.origin.x, y: originalBounds.origin.y, width: self.contentSize.width, height: self.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.contentSize.height)
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return NSMutableData() }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        self.bounds = originalBounds
        // Save pdf data
        return pdfData
        //self.saveTablePdf(data: pdfData)
        
    }
    
//    // Save pdf file in document directory
//    func saveTablePdf(data: NSMutableData){
//        //NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let resourceDocPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]//(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
//        //let pdfNameFromUrl = "Stylopay_Transaction_Report.pdf"
//        data.write(toFile: "\(resourceDocPath)/Stylopay_Transaction_Report.pdf", atomically: true)
//        let activityViewController = UIActivityViewController(activityItems: ["Stylopay", data], applicationActivities: nil)
//        present(activityViewController, animated: true, completion: nil)
//        //let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
////        do {
////            try data.write(toFile: "\(resourceDocPath)/Stylopay_Transaction_Report.pdf", atomically: true)
////
////            print("pdf successfully saved!")
////            return resourceDocPath.path
////        } catch {
////            print("Pdf could not be saved")
////            return ""
////        }
//
////        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
////        let docDirectoryPath = paths[0]
////        let pdfPath = docDirectoryPath.appendingPathComponent("tablePdf.pdf")
////        if data.write(to: pdfPath, atomically: true) {
////            return pdfPath.path
////        } else {
////            return ""
////        }
//    }
}
