//
//  ThemeManager.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 29/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import Foundation
import UIKit

enum Theme: Int {

    case theme1, theme2

    var mainColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("B72B7E")
        case .theme2:
            return UIColor().colorFromHexString("1CB2E2")
        }
    }

    //Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .theme1:
            return .default
        case .theme2:
            return .black
        }
    }

    var backgroundImage: UIImage? {
        return self == .theme1 ? UIImage(named: "background") : nil
    }

    var backgroundColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("000000")
        case .theme2:
            return UIColor().colorFromHexString("ffffff")
        }
    }
    
    var cardOptionsBackgroundColor: UIColor {
        switch self {
        case .theme1:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        case .theme2:
            return #colorLiteral(red: 0.9289371967, green: 0.9486234784, blue: 0.9553471208, alpha: 1)
        }
    }
    
    var backgroundImageHidden: Bool {
        switch self {
        case .theme1:
            return false
        case .theme2:
            return true
        }
    }

    var secondaryColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return UIColor().colorFromHexString("000000")
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return UIColor().colorFromHexString("000000")
        }
    }
    var subtitleTextColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return UIColor().colorFromHexString("000000")
        }
    }
    
    
    var cardBackgroundImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.viewbackgroundRedImage!
        case .theme2:
            return UIImage(named: "stylopaycardlight")!
        }
    }
    
    var bottomSelectedTabButtonColor : UIColor{
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("B72B7E")
        case .theme2:
            return UIColor().colorFromHexString("1CB2E2")
        }
    }
    
    
    var bottomUnselectedTabButtonColor : UIColor{
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return UIColor().colorFromHexString("667176")
        }
    }
    
    var borderColor : UIColor{
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("ffffff")
        case .theme2:
            return UIColor().colorFromHexString("E2EAEE")
        }
    }
    
    var disableTextColor : UIColor{
        switch self {
        case .theme1:
            return UIColor().colorFromHexString("667176")
        case .theme2:
            return UIColor().colorFromHexString("CBD2D6")
        }
    }
    
    var buttonsBackgroundImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.viewbackgroundRedImage!
        case .theme2:
            return AssetsImages.viwebackgroundBlueImage!
        }
    }
    
    var doubleArrowImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.doubleArrowWhite!
        case .theme2:
            return AssetsImages.douobleArrowBlue!
        }
    }
    
    var downloadImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.downloadRed!
        case .theme2:
            return AssetsImages.downloadBluw!
        }
    }
    
    var familyImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.friendFamilyOptionIcon!
        case .theme2:
            return AssetsImages.friendFamilyOptionLightIcon!
        }
    }
    
    var corporateImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.corporateOptionIcon!
        case .theme2:
            return AssetsImages.corporateOptionLightIcon!
        }
    }
    
    var borderColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.redBorderImage!
        case .theme2:
            return AssetsImages.blueBorderImage!
        }
    }
    
    var selectedManageCardImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.manageCardIconImage!
        case .theme2:
            return AssetsImages.manageCardBlueIconImage!
        }
    }
    var selectedTransferImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.transferRedImage!
        case .theme2:
            return AssetsImages.transferBlueImage!
        }
    }
    
    var selectedExchangeImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.exchangeImage!
        case .theme2:
            return AssetsImages.exchangeBlueImage!
        }
    }
    
    var selectedRecentImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.moreOptionsIconImage!
        case .theme2:
            return AssetsImages.recentBlueIconImage!
        }
    }
    
    var selectedMoreOptionsImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.moreIconImage!
        case .theme2:
            return AssetsImages.moreBlueIconImage!
        }
    }
    
    var sgdColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.sgdRedIconImage!
        case .theme2:
            return AssetsImages.sgdBlueIconImage!
        }
    }
    
    var switchOnImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.switchOnImage!
        case .theme2:
            return AssetsImages.switchOnBlueImage!
        }
    }
    
    var cameraColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.cameraImage!
        case .theme2:
            return AssetsImages.cameraBlueImage!
        }
    }
    
    var uploadColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.uploadImage!
        case .theme2:
            return AssetsImages.uploadBlueImage!
        }
    }
    
    var dropDownColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.dropdownRedImage!
        case .theme2:
            return AssetsImages.dropdownBlueImage!
        }
    }
    
    var uncheckBoxColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.UncheckedBoxImage!
        case .theme2:
            return AssetsImages.UncheckedBoxGreyImage!
        }
    }
    
    var checkBoxColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.checkedBoxImage!
        case .theme2:
            return AssetsImages.checkedBoxBlueImage!
        }
    }
    
    var addColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.addImage!
        case .theme2:
            return AssetsImages.addBlueImage!
        }
    }
    
    var completedTrackColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.completedTrackImage!
        case .theme2:
            return AssetsImages.completedTrackBlueImage!
        }
    }
    
    var defaultProfileImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.profileImage!
        case .theme2:
            return AssetsImages.profileBlueImage!
        }
    }
    
    var fingerPrintImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.fingerPrintIcon!
        case .theme2:
            return AssetsImages.fingerPrintLightIcon!
        }
    }
    
    var rightArrowImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.rightarrowRedIconImage!
        case .theme2:
            return AssetsImages.rightarrowBlueIconImage!
        }
    }
    
    var backImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.returnRedIconImage!
        case .theme2:
            return AssetsImages.returnBlueIconImage!
        }
    }
    
    var nextImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.nextRedIconImage!
        case .theme2:
            return AssetsImages.nextBlueIconImage!
        }
    }
    
    var dataUploadedIconColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.dataUploadedImage!
        case .theme2:
            return AssetsImages.dataUploadedBlueImage!
        }
    }
    
    var currentPageIconColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.currentPageImage!
        case .theme2:
            return AssetsImages.currentPageblueImage!
        }
    }
    
    var nextPageIconColorImage : UIImage{
        switch self {
        case .theme1:
            return AssetsImages.nextPageImage!
        case .theme2:
            return AssetsImages.nextPageblueImage!
        }
    }
}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"

/// This will let you use a theme in the app.
class ThemeManager {
    
    /// currentTheme: static function store current theme.
    /// Returns: Theme
    /// Parameters: None
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .theme1
        }
    }
    
    /// applyTheme: static function applyTheme.
    /// Returns: None
    /// Parameters: theme
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        //sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.mainColor]
    
    }
}
