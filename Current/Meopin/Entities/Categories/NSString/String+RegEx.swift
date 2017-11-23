//
//  String+RegEx.swift
//  chilax
//
//  Created by Tops on 6/26/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

extension String {
    func isValidString(_ string: String, _ type: Global.kStringType) -> Bool {
        var charSet: CharacterSet?
        if type == Global.kStringType.AlphaNumeric {
            charSet = self.regexForAlphaNumeric()
        }
        else if type == Global.kStringType.AlphabetOnly {
            charSet = self.regexForAlphabetsOnly()
        }
        else if type == Global.kStringType.NumberOnly {
            charSet = self.regexForNumbersOnly()
        }
        else if type == Global.kStringType.Fullname {
            charSet = self.regexForFullnameOnly()
        }
        else if type == Global.kStringType.Username {
            charSet = self.regexForUsernameOnly()
        }
        else if type == Global.kStringType.Email {
            charSet = self.regexForEmail()
        }
        else if type == Global.kStringType.PhoneNumber {
            charSet = self.regexForPhoneNumber()
        }
        else {
            return true
        }
        
        let isValid: Bool = !(self.isValidStringForCharSet(string, charSet: charSet!).characters.count == 0)
        return isValid
    }

    func isValidStringForCharSet(_ string: String, charSet: CharacterSet) -> String {
        var strResult: String = ""
        let scanner = Scanner(string: string)
        var strScanResult : NSString?
        
        scanner.charactersToBeSkipped = nil
        
        while !scanner.isAtEnd {
            if scanner.scanUpToCharacters(from: charSet, into: &strScanResult) {
                strResult = strResult + (strScanResult! as String)
            }
            else {
                if !scanner.isAtEnd {
                    scanner.scanLocation = scanner.scanLocation + 1
                }
            }
        }
        return strResult
    }
    
    func regexForAlphabetsOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n_!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~`-1234567890 ")
        return regex
    }
    
    func regexForNumbersOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "1234567890").inverted
        return regex
    }
    
    func regexForAlphaNumeric() -> CharacterSet {
        let regex = CharacterSet(charactersIn: " \n_!@#$%^&*()[ ]{}'\".,<>:;|\\/?+=\t~`")
        return regex
    }
    
    func regexForFullnameOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n_!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~`-1234567890")
        return regex
    }
    
    func regexForUsernameOnly() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "-_.1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
        return regex
    }
    
    func regexForPhoneNumber() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "+1234567890").inverted
        return regex
    }
    
    func regexForEmail() -> CharacterSet {
        let regex: CharacterSet = CharacterSet(charactersIn: "\n!#$^&*()[ ]{}'\",<>:;|\\/?=\t~`")
        return regex
    }

    func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9,// Special Characters
            0x1D000...0x1F77F,          // Emoticons
            0x2100...0x27BF,            // Misc symbols and Dingbats
            0xFE00...0xFE0F,            // Variation Selectors
            0x1F900...0x1F9FF:          // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    func validatePassword() -> Bool {
//        let capitalLetterRegEx  = ".*[A-Z]+.*"
//        let capitaltest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
//        let capitalresult = capitaltest.evaluate(with: self)
        
        let nonUpperCase = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        let letters = self.components(separatedBy: nonUpperCase)
        let strUpper: String = letters.joined()
        
        let smallLetterRegEx  = ".*[a-z]+.*"
        let samlltest = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        let smallresult = samlltest.evaluate(with: self)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numbertest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = numbertest.evaluate(with: self)
        
        return (strUpper.characters.count >= 2) && smallresult && numberresult
    }
    
    func formatPhoneNumber () -> String {
        var strTemp = self
        strTemp = strTemp.replacingOccurrences(of: "(", with: "")
        strTemp = strTemp.replacingOccurrences(of: ")", with: "")
        strTemp = strTemp.replacingOccurrences(of: " ", with: "")
        strTemp = strTemp.replacingOccurrences(of: "-", with: "")
        strTemp = strTemp.replacingOccurrences(of: "*", with: "")
        
        return strTemp
    }
}
