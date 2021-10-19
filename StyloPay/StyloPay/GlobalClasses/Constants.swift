//
//  Constants.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 09/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import Foundation
import UIKit

#if DEBUG
let clientID = "958d5631-e1a7-461c-8189-b8ce1042640c"
let remittanceXApiKey = "f33CQSi6x83mFrUv4Wi59fInMyhW7H89fst0d5k5"
let service = "myService"
let account = "myAccount"
let agentCode = "Agent_code"
let subAgentCode = "Sub_Agent_code"
let clientAgentSubagentName = "StylopayDemo"
let liveBaseUrl = "https://developer.sandbox.stylopay.com"
let baseUrl = "https://developer.sandbox.stylopay.com:8082"
let mainUrl = "\(liveBaseUrl)/NISG"
let plasticID = "100100"
let liveClientHashID = "cebd2dfb-b010-48ef-b2f2-ac7e640e3a68"
let liveWalletXAPIKey = "tDwjoMFPiL1XDYTjb8H313BWbmFlh1ve21usj7Oj"
let isSandBox = true
let versionName = "Version : 1.2021.08.03.S"
//let clientID = "958d5631-e1a7-461c-8189-b8ce1042640c"
//let remittanceXApiKey = "f33CQSi6x83mFrUv4Wi59fInMyhW7H89fst0d5k5"
//let service = "myService"
//let account = "myAccount"
//let agentCode = "Agent_code"
//let subAgentCode = "Sub_Agent_code"
//let clientAgentSubagentName = "StylopayDemo"
//let liveBaseUrl = "https://developer.stylopay.com" //"http://34.245.17.237:8081"//
//let mainUrl = "\(liveBaseUrl)/NIUM"
//let plasticID = "756100101"
//let liveClientHashID = "929b6487-e864-4d4e-9da4-9f4e9addbd52"
//let liveWalletXAPIKey = "mv6uQwbi6Yb1wazN9TeY7q90uZrLPP119kwBZPz7"

#else
let clientID = "958d5631-e1a7-461c-8189-b8ce1042640c"
let remittanceXApiKey = "f33CQSi6x83mFrUv4Wi59fInMyhW7H89fst0d5k5"
let service = "myService"
let account = "myAccount"
let agentCode = "Agent_code"
let subAgentCode = "Sub_Agent_code"
let clientAgentSubagentName = "StylopayDemo"
let liveBaseUrl = "https://developer.sandbox.stylopay.com"
let mainUrl = "\(liveBaseUrl)/NISG"
let plasticID = "100100"
let liveClientHashID = "cebd2dfb-b010-48ef-b2f2-ac7e640e3a68"
let liveWalletXAPIKey = "tDwjoMFPiL1XDYTjb8H313BWbmFlh1ve21usj7Oj"
let isSandBox = true
let versionName = "Version : 1.2021.08.03.S"
//let clientID = "958d5631-e1a7-461c-8189-b8ce1042640c"
//let remittanceXApiKey = "f33CQSi6x83mFrUv4Wi59fInMyhW7H89fst0d5k5"
//let service = "myService"
//let account = "myAccount"
//let agentCode = "Agent_code"
//let subAgentCode = "Sub_Agent_code"
//let clientAgentSubagentName = "StylopayDemo"
//let liveBaseUrl = "https://developer.stylopay.com" //"http://34.245.17.237:8081"//
//let mainUrl = "\(liveBaseUrl)/NIUM"
//let plasticID = "756100101"
//let liveClientHashID = "929b6487-e864-4d4e-9da4-9f4e9addbd52"
//let liveWalletXAPIKey = "mv6uQwbi6Yb1wazN9TeY7q90uZrLPP119kwBZPz7"

#endif




//MARK:- Constants
public struct Constants {
    static let kAppDelegate = UIApplication.shared.delegate as? AppDelegate
    static let kUserDefaults = UserDefaults.standard
    static let kScreenWidth = UIScreen.main.bounds.width
    static let kScreenHeight = UIScreen.main.bounds.height
    static let kAppDisplayName = "Supreme"
    static let cardDisplayName = "SUPREME FINTECH WALLET"
    static let subAgentValue = "0"
    static let agentValue = "101"
    static let kDeviceType = "ios"
    static let errorMsg = "Session Terminated \nLogging Out..."
    static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
    static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
}

//MARK:- Storyboard Identity
public struct Storyboard {
    static let kMainStoryboard = UIStoryboard(name: "Main",bundle: nil)
}

//MARK:- Currency Code and Balance Data Set
var currencyData = !isSandBox ?
[
    ["iso2":"AU","name": "Australia","isd":"61","country": "AUS", "currencyCode": "AUD","currencySymbol": "A$", "currencyIcon" : "AUD", "countryFlag": "australia", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"DE","name": "Germany","isd":"49","country": "DEU", "currencyCode": "EUR","currencySymbol": "€", "currencyIcon" : "euro", "countryFlag" : "europe", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"SG","name": "Singapore","isd":"65","country": "SGP", "currencyCode": "SGD","currencySymbol": "S$", "currencyIcon" : "dollar12", "countryFlag": "singapore", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"GB","name": "United Kingdom","isd":"44","country": "GBR", "currencyCode": "GBP","currencySymbol": "£", "currencyIcon" : "GBP", "countryFlag" : "uk", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"IN","name": "India","isd":"91","country": "IND", "currencyCode": "INR","currencySymbol": "₹", "currencyIcon" : "yenna", "countryFlag" : "india", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"US","name": "United States of America","isd":"1","country": "USA", "currencyCode": "USD","currencySymbol": "$", "currencyIcon" : "USD", "countryFlag" : "usa", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"HK","name": "HongKong","isd":"852","country": "HKG", "currencyCode": "HKD","currencySymbol": "HK$", "currencyIcon" : "HKD", "countryFlag" : "hong-kong", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"ID","name": "Indonesia","isd":"62","country": "IDN", "currencyCode": "IDR","currencySymbol": "Rp", "currencyIcon" : "rp", "countryFlag" : "indonesia", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"JP","name": "Japan","isd":"81","country": "JPN", "currencyCode": "JPY","currencySymbol": "¥", "currencyIcon" : "yen", "countryFlag" : "japan", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"KR","name": "South Korea","isd":"82","country": "KOR", "currencyCode": "KRW","currencySymbol": "₩", "currencyIcon" : "KRW", "countryFlag" : "SKflag", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"MY","name": "Malaysia","isd":"60","country": "MYS", "currencyCode": "MYR","currencySymbol": "RM", "currencyIcon" : "MYR", "countryFlag" : "malaysia", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"TW","name": "Taiwan","isd":"886","country": "TWN", "currencyCode": "TWD","currencySymbol": "元", "currencyIcon" : "twd", "countryFlag" : "taiwan", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"TH","name": "Thailand","isd":"66","country": "THA", "currencyCode": "THB","currencySymbol": "฿", "currencyIcon" : "THB", "countryFlag" : "thailand", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"VN","name": "Vietnam","isd":"84","country": "VNM", "currencyCode": "VND","currencySymbol": "₫", "currencyIcon" : "VND", "countryFlag" : "vietnam", "isCurrencyAvailable": false, "walletBalance": 0.00],
]
:
[
    ["iso2":"DE","name": "Germany","isd":"49","country": "DEU", "currencyCode": "EUR","currencySymbol": "€", "currencyIcon" : "euro", "countryFlag" : "europe", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"SG","name": "Singapore","isd":"65","country": "SGP", "currencyCode": "SGD","currencySymbol": "S$", "currencyIcon" : "dollar12", "countryFlag": "singapore", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"GB","name": "United Kingdom","isd":"44","country": "GBR", "currencyCode": "GBP","currencySymbol": "£", "currencyIcon" : "GBP", "countryFlag" : "uk", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"IN","name": "India","isd":"91","country": "IND", "currencyCode": "INR","currencySymbol": "₹", "currencyIcon" : "yenna", "countryFlag" : "india", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ["iso2":"US","name": "United States of America","isd":"1","country": "USA", "currencyCode": "USD","currencySymbol": "$", "currencyIcon" : "USD", "countryFlag" : "usa", "isCurrencyAvailable": false, "walletBalance": 0.00],
]
//MARK:- Proof Screen Type
enum ProofScreenType: String {
    case ID, SELFIE, ADDRESS, PROFILE, AUTH
}

//MARK:- Compliance Status
enum ComplianceStatusType: String {
    case IN_PROGRESS, ACTION_REQUIRED, COMPLETED, RFI_REQUESTED, REJECT, RFI_RESPONDED, ERROR
}

//MARK:- Image Set
//MARK:- Image Set
public struct AssetsImages {
    static let logo = UIImage(named: "stylopay_logo")
    static let firstOnBoarding = UIImage(named: "onboarding1")
    static let secondOnBoarding = UIImage(named: "onboarding2")
    static let background = UIImage(named: "background")
    static let currentPageImage = UIImage(named: "dots")
    static let nextPageImage = UIImage(named: "Oval")
    static let currentPageblueImage = UIImage(named: "dotsBlue")
    static let sun = UIImage(named: "sun")
    static let nextPageblueImage = UIImage(named: "ovalBlue")
    static let pendingTrackImage = UIImage(named: "pendingTrack")
    static let completedTrackImage = UIImage(named: "completedTrack")
    static let completedTrackBlueImage = UIImage(named: "trackCompleteBlue")
    static let dataNotUploadedImage = UIImage(named: "notyet")
    static let dataUploadedImage = UIImage(named: "add")
    static let dataUploadedBlueImage = UIImage(named: "done")
    static let UncheckedBoxImage = UIImage(named: "uncheckedBox")
    static let UncheckedBoxGreyImage = UIImage(named: "uncheckBoxGrey")
    static let checkedBoxBlueImage = UIImage(named: "Switches-Checkbox OnBlue")
    static let checkedBoxImage = UIImage(named: "CheckboxOnRed")
    static let addImage = UIImage(named: "add red")
    static let addBlueImage = UIImage(named: "addBlue")
    static let profileImage = UIImage(named: "chatbot-1")
    static let profileBlueImage = UIImage(named: "chatbotBlue")
    static let switchOnImage = UIImage(named: "switch(on)")
    static let switchOffImage = UIImage(named: "switch(off)")
    static let switchOnBlueImage = UIImage(named: "switchOnBlue")
    static let cameraImage = UIImage(named: "camera")
    static let cameraBlueImage = UIImage(named: "cameraBlue")
    static let uploadImage = UIImage(named: "uploadcloud")
    static let uploadBlueImage = UIImage(named: "uploadCloudBlue")
    static let bellIconImage = UIImage(named: "bell-red")
    static let blueBorderImage = UIImage(named: "registerButtonHolllowLight")
    static let redBorderImage = UIImage(named: "border")
    static let backRedIconImage = UIImage(named: "return")
    static let dropdownRedImage = UIImage(named: "down")
    @available(iOS 13.0, *)
    static let downArrow = UIImage(systemName: "arrowtriangle.down.fill")
    @available(iOS 13.0, *)
    static let upArrow = UIImage(systemName: "arrowtriangle.up.fill")
    static let excamalation = UIImage(named: "excamalation_icon")
    static let dropdownBlueImage = UIImage(named: "downBlue")
    static let viewbackgroundRedImage = UIImage(named: "register button")
    static let viwebackgroundBlueImage = UIImage(named: "registerButtonLight")
    static let idAddBanIconImage = UIImage(named: "internet")
    static let dashboardIconImage = UIImage(named: "dashboard")
    static let crossIconImage = UIImage(named: "delete")
    static let stylopayWhiteLogoImage = UIImage(named: "stylopayWhiteLogo")
    static let visaPayLogoImage = UIImage(named: "visa-pay-logo")

    static let manageCardIconImage = UIImage(named: "loadmoney1-red")
    static let transferRedImage = UIImage(named: "load money")
    static let exchangeImage = UIImage(named: "exchange-red")
    static let moreOptionsIconImage = UIImage(named: "tx")
    static let moreIconImage = UIImage(named: "more-red")

    static let sgdRedIconImage = UIImage(named: "dollar")
    static let sgdBlueIconImage = UIImage(named: "sgdBlue")
    static let nextRedIconImage = UIImage(named: "go")
    static let nextBlueIconImage = UIImage(named: "goBlue")
    static let rightarrowRedIconImage = UIImage(named: "rightarrow")
    static let rightarrowBlueIconImage = UIImage(named: "rightArrowBlue")
    static let returnRedIconImage = UIImage(named: "return")
    static let returnBlueIconImage = UIImage(named: "returnBlue")

    static let euroSymbol = UIImage(named: "euro")
    static let gbpSymbol = UIImage(named: "GBP")
    static let inrSymbol = UIImage(named: "yenna")
    static let sdollarSymbol = UIImage(named: "dollar12")
    static let dollarSymbol = UIImage(named: "USD")

    static let manageCardUnselected = UIImage(named: "load money-1")
    static let transferUnselected = UIImage(named: "loadmoneyUnselected")
    static let exchangeUnselected = UIImage(named: "exchange")
    static let recentUnselectedIconImage = UIImage(named: "options")
    static let moreUnselectedIconImage = UIImage(named: "more")

    static let doubleArrowWhite = UIImage(named: "doubleArrow")
    static let douobleArrowBlue = UIImage(named: "doubleArrowLight")
    static let downloadRed = UIImage(named: "download")
    static let downloadBluw = UIImage(named: "downloadLight")

    static let manageCardBlueIconImage = UIImage(named: "savedcardblue")
    static let transferBlueImage = UIImage(named: "loadMoneyBlue")
    static let exchangeBlueImage = UIImage(named: "exchangeBlue")
    static let recentBlueIconImage = UIImage(named: "txBlue")
    static let moreBlueIconImage = UIImage(named: "moreBlue")

    static let sideMenuIcon = UIImage(named: "leftMenu")
    static let friendFamilyOptionIcon = UIImage(named: "family")
    static let corporateOptionIcon = UIImage(named: "corporate-1")
    static let friendFamilyOptionLightIcon = UIImage(named: "family-light-theme")
    static let corporateOptionLightIcon = UIImage(named: "corporate-light-theme")
    static let addonLogoIcon = UIImage(named: "addon")
    static let assignedLogoIcon = UIImage(named: "assigned")

    static let fingerPrintLightIcon = UIImage(named: "fingerprint")
    static let fingerPrintIcon = UIImage(named: "fingerprint-red")
}


func convertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
}

func convertBase64StringToImage (imageBase64String:String) -> UIImage {
    let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
    let image = UIImage(data: imageData!)
    return image!
}

func decodeBase64String(base64Encoded: String) -> String{
    let decodedData = Data(base64Encoded: base64Encoded)!
    let decodedString = String(data: decodedData, encoding: .utf8)!
    return decodedString
}


func removeCredentials(){
    CustomUserDefaults.isLoggedIn(data: false)
    CustomUserDefaults.removeMiddleName()
    CustomUserDefaults.removetFirstName()
    CustomUserDefaults.removeLastName()
    CustomUserDefaults.removeComplianceStatus()
    CustomUserDefaults.removeEmailAddress()
    KeychainService.removePassword(service: service, account: account)
    CustomUserDefaults.removeCustomerId()
    CustomUserDefaults.removeAccessToken()
    CustomUserDefaults.removeRefreshToken()
    CustomUserDefaults.removeWalletHashId()
    CustomUserDefaults.removeCustomerHashId()
    CustomUserDefaults.removeWalletAccessToken()
    CustomUserDefaults.removetWalletRefreshToken()
    CustomUserDefaults.removeIsdCode()
    CustomUserDefaults.removeMobileNumber()
    CustomUserDefaults.removeisKyc()
    CustomUserDefaults.removePhoneNumberVerified()
    CustomUserDefaults.removeisIsAuth()
    //CustomUserDefaults.removeWalletUsername()
}


public struct ConstantsMessages {
    static let kConnectionFailed = "Looks like there is some problem in your internet connection,\nPlease try again after some time."
    static let kNoInternet = "Please check your internet connection."
    static let kNetworkFailure = "Looks like there is some network error,\nPlease try after some time."
    static let kSomethingWrong = "Something went wrong\nPlease try again soon!"
    static let kCheckMark = "Please agree to the Terms of Use and Privacy Policy"
}

let countryList = [ "Algeria", "Angola", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahrain", "Bangladesh", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Brazil", "British Indian Ocean Territory", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cameroon", "Canada", "Cape Verde", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos Islands", "Colombia", "Comoros", "Cook Islands", "Costa Rica", "Croatia", "Cuba", "Curacao", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Ecuador", "Egypt", "El Salvador", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "French Polynesia", "Gabon", "Gambia", "Georgia", "Germany", "Gibraltar", "Greece", "Greenland", "Haiti", "Honduras", "Hong Kong", "Hungary", "India", "Indonesia", "Ireland", "Israel", "Italy", "Ivory Coast", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Mauritania", "Mexico", "Micronesia", "Moldova", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Niger", "Nigeria", "Niue", "Norway", "Oman", "Palau", "Palestine", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Qatar", "Republic of the Congo", "Romania", "Russia", "Rwanda", "Samoa", "San Marino", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Togo", "Tokelau", "Tonga", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican", "Venezuela", "Vietnam", "Zambia"]

let countryFlags = [ "algeria", "angola", "argentina", "armenia", "aruba", "australia", "austria", "azerbaijan", "bahrain", "bangladesh", "belarus", "belgium", "belize", "benin", "bhutan", "bolivia", "bosnia-and-herzegovina", "brazil", "british-indian-ocean-territory", "brunei", "bulgaria", "burkina-faso", "burundi", "cameroon", "canada", "cape-verde", "central-african-republic", "chad", "chile", "china", "christmas-island", "cocos-island", "colombia", "comoros", "cook-islands", "costa-rica", "croatia", "cuba", "curacao", "cyprus", "czech-republic", "denmark", "djibouti", "ecuador", "egypt", "el-salvador", "estonia", "ethiopia", "fiji", "finland", "france", "french-polynesia", "gabon", "gambia", "georgia", "germany", "gibraltar", "greece", "greenland", "haiti", "honduras", "hong-kong", "hungary", "india", "indonesia", "ireland", "israel", "italy", "ivory-coast", "japan", "jordan", "kazakhstan", "kenya", "kiribati", "kosovo", "kuwait", "kyrgyzstan", "laos", "latvia", "lebanon", "lesotho", "liberia", "libya", "liechtenstein", "lithuania", "luxembourg", "Macedonia", "madagascar", "malawi", "malaysia", "maldives", "mali", "malta", "mauritania", "mexico", "micronesia", "moldova", "mongolia", "montenegro", "morocco", "mozambique", "myanmar", "namibia", "nauru", "nepal", "netherlands", "new-zealand", "niger", "nigeria", "niue", "norway", "oman", "palau", "palestine", "papua-new-guinea", "paraguay", "peru", "philippines", "pitcairn-islands", "poland", "portugal", "qatar", "republic-of-the-congo", "romania", "russia", "rwanda", "samoa", "san-marino", "saudi-arabia", "senegal", "serbia", "seychelles", "sierra-leone", "singapore", "slovakia", "slovenia", "solomon-islands", "somalia", "south-africa", "SKflag", "south-sudan", "spain", "sri-lanka", "sudan", "suriname", "swaziland", "sweden", "switzerland", "syria", "taiwan", "tajikistan", "tanzania", "thailand", "togo", "tokelau", "tonga", "tunisia", "turkey", "turkmenistan", "tuvalu", "uganda", "ukraine", "united-arab-emirates", "uk", "united-states-of-america", "uruguay", "uzbekistan", "vanuatu", "vatican-city", "venezuela", "vietnam", "zambia"]


let countryCodeList = ["213", "244", "54", "374", "297", "61", "43", "994", "973", "880", "375", "32", "501", "229", "975", "591", "387", "55", "246", "673", "359", "226", "257", "237", "1", "238", "236", "235", "56", "86", "61", "61", "57", "269", "682", "506", "385", "53", "599", "357", "420", "45", "253", "593", "20", "503", "372", "251", "679", "358", "33", "689", "241", "220", "995", "49", "350", "30", "299", "509", "504", "852", "36", "91", "62", "353", "972", "39", "225", "81", "962", "7", "254", "686", "383", "965", "996", "856", "371", "961", "266", "231", "218", "423", "370", "352", "389", "261", "265", "60", "960", "223", "356", "222", "52", "691", "373", "976", "382", "212", "258", "95", "264", "674", "977", "31", "64", "227", "234", "683", "47", "968", "680", "970", "675", "595", "51", "63", "64", "48", "351", "974", "242", "40", "7", "250", "685", "378", "966", "221", "381", "248", "232", "65", "421", "386", "677", "252", "27", "82", "211", "34", "94", "249", "597", "268", "46", "41", "963", "886", "992", "255", "66", "228", "690", "676", "216", "90", "993", "688", "256", "380", "971", "44", "1", "598", "998", "678", "379", "58", "84", "260"]

let isoCode2 = ["DZ", "AO", "AR", "AM", "AW", "AU", "AT", "AZ", "BH", "BD", "BY", "BE", "BZ", "BJ", "BT", "BO", "BA", "BR", "IO", "BN", "BG", "BF", "BI", "CM", "CA", "CV", "CF", "TD", "CL", "CN", "CX", "CC", "CO", "KM", "CK", "CR", "HR", "CU", "CW", "CY", "CZ", "DK", "DJ", "EC", "EG", "SV", "EE", "ET", "FJ", "FI", "FR", "PF", "GA", "GM", "GE", "DE", "GI", "GR", "GL",  "HT", "HN", "HK", "HU", "IN", "ID", "IE", "IL", "IT", "CI", "JP", "JO", "KZ", "KE", "KI", "XK", "KW", "KG", "LA", "LV", "LB", "LS", "LR", "LY", "LI", "LT", "LU", "MK", "MG", "MW", "MY", "MV", "ML", "MT", "MR",  "MX", "FM", "MD", "MN", "ME", "MA", "MZ", "MM", "NA", "NR", "NP", "NL", "NZ", "NE", "NG", "NU", "NO", "OM", "PW", "PS", "PG", "PY", "PE", "PH", "PN", "PL", "PT", "QA", "CG", "RO", "RU", "RW", "WS", "SM", "ST", "SN", "RS", "SC", "SL", "SG", "SK", "SI", "SB", "SO", "ZA", "KR", "SS", "ES", "LK", "SD", "SR", "SZ", "SE", "CH", "SY", "TW", "TJ", "TZ", "TH", "TG", "TK", "TO", "TN", "TR", "TM", "TV", "UG", "UA", "AE", "GB", "US", "UY", "UZ", "VU", "VA", "VE", "VN", "ZM"]

let isoCode3 = ["DZA", "AGO", "ARG", "ARM", "ABW", "AUS", "AUT", "AZE", "BHR", "BGD", "BLR", "BEL", "BLZ", "BEN", "BTN", "BOL", "BIH", "BRA", "IOT", "BRN", "BGR", "BFA", "BDI", "CMR", "CAN", "CPV", "CAF", "TCD", "CHL", "CHN", "CXR", "CCK", "COL", "COM", "COK", "CRI", "HRV", "CUB", "CUW", "CYP", "CZE", "DNK", "DJI", "ECU", "EGY", "SLV", "EST", "ETH", "FJI", "FIN", "FRA", "PYF", "GAB", "GMB", "GEO", "DEU", "GIB", "GRC", "GRL", "HTI", "HND", "HKG", "HUN", "IND", "IDN", "IRL", "ISR", "ITA", "CIV", "JPN", "JOR", "KAZ", "KEN", "KIR", "XKX", "KWT", "KGZ", "LAO", "LVA", "LBN", "LSO", "LBR", "LBY", "LIE", "LTU", "LUX", "MKD", "MDG", "MWI", "MYS", "MDV", "MLI", "MLT", "MRT", "MEX", "FSM", "MDA", "MNG", "MNE", "MAR", "MOZ", "MMR", "NAM", "NRU", "NPL", "NLD", "NZL", "NER", "NGA", "NIU", "NOR", "OMN", "PLW", "PSE", "PNG", "PRY", "PER", "PHL", "PCN", "POL", "PRT", "QAT", "COG", "ROU", "RUS", "RWA", "WSM", "SMR", "STP", "SEN", "SRB", "SYC", "SLE", "SGP", "SVK", "SVN", "SLB", "SOM", "ZAF", "KOR", "SSD", "ESP", "LKA", "SDN", "SUR", "SWZ", "SWE", "CHE", "SYR", "TWN", "TJK", "TZA", "THA", "TGO", "TKL", "TON", "TUN", "TUR", "TKM", "TUV", "UGA", "UKR", "ARE", "GBR", "USA", "URY", "UZB", "VUT", "VAT", "VEN", "VNM", "ZMB"]


// Nexmo

let nexmo_verify_url = "https://api.nexmo.com/verify/json"
let nexmo_check_url  = "https://api.nexmo.com/verify/check/json?"
let nexmo_api_key = "501bdeca"
let nexmo_secret_key = "HiMKR1PX3K5QhedX"
let brand =  "Supreme Fintech"
