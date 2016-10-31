//
//  cryptoClass.swift
//  letter
//
//  Created by Robert Herrera on 5/15/16.
//  Copyright © 2016 Robert Herrera. All rights reserved.
//

import Foundation
import CryptoSwift

class cryptoClass {
    
    func encryptDataAESText(text: String, user_password: String) -> String? {
        
        let input = text
        
        let keyDerivative = user_password.sha512()
    
        
        let cipherKey = (keyDerivative as NSString).substringToIndex(16)
        
        
        let startIndex = keyDerivative.startIndex.advancedBy(16)
        let endIndex   = keyDerivative.startIndex.advancedBy(32)

        
        let newIV = keyDerivative.substringWithRange(Range<String.Index>(startIndex ..< endIndex))
    
        let ciphertext = try! input.encrypt(AES(key: cipherKey, iv:newIV,blockMode: .CBC)).toBase64()
        
        return ciphertext
        
        
        
    }
    
    
    func decryptDataAESText(text: String?, user_password: String) -> String? {
        
        
        let keyDerivative = user_password.sha512()
        
        
        let cipherKey = (keyDerivative as NSString).substringToIndex(16)
        
        
        let startIndex = keyDerivative.startIndex.advancedBy(16)
        let endIndex   = keyDerivative.startIndex.advancedBy(32)
        
        
        let newIV = keyDerivative.substringWithRange(Range<String.Index>(startIndex ..< endIndex))
        
        let decrypted = try! text?.decryptBase64ToString(AES(key: cipherKey, iv:newIV))
        
        
        return decrypted
        
        
        
    }
    
    
}
