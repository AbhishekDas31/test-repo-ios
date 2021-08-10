//
//  ProofsModel.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 18/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

struct ProofsModel{
    
    var identificationType = ""
    var identificationValue = ""
    var identificationIssuingAuthority = ""
    var identificationIssuingCountry = ""
    var identificationIssuingDate = ""
    var identificationDocExpiry = ""
    var identificationDocHolderName = ""
    var identificationDocIssuanceCountry = ""
    var identificationFileDocumentArray = [ProofsDocumentFileModel]()
    var screenType = ""
    var documentType = ""
    var documentNUmber = ""
    var issuingAuthority = ""
    var issuianceDate = ""
    var uploadDocument = ""
    var uploadDocumentData = Data()
    var uploadImage = UIImage()
    var rfiHashId = ""

}

struct ProofsDocumentFileModel{
    
    var fileName = ""
    var fileType = ""
    var document = ""
    var uploadDocumentData = Data()
    var uploadImage = UIImage()

}
