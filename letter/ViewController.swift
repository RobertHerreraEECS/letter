//
//  ViewController.swift
//  letter
//
//  Created by Robert Herrera on 5/15/16.
//  Copyright © 2016 Robert Herrera. All rights reserved.
//

import UIKit

/**
 *
 * @description: [Steganographic message] user message shall be embedded within image and sent to server. Receiver of message shall use fingerprint (Touch I.d.) to authenticate and view message while finger is present. Message shall only be viewable up to 24 hours.
 */

class ViewController: UIViewController {
    
    private var message : String? = ""
    private let password: String? = "mtfbwy_rob_07"
    private let picture: UIImage? = UIImage(named: "fox")
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var beforePic: UIImageView!
    @IBOutlet weak var afterPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didFinishTextField(sender: UIButton) {
        
        message = textField.text
        
        textField.text = ""
        
        let ciphertext: String? = cryptoClass().encryptDataAESText(message!,user_password: password!)
        
        let raw_data = [UInt8](ciphertext!.utf8)
        
        
        beforePic.image = UIImage(named: "fox")
        
        let transform = UIImageJPEGRepresentation(beforePic.image!, 1.0)
        
        var byteArray = transform!.arrayOfBytes()
        
        let compatibility: Bool = checkMessageSizeFromString(raw_data, picture: byteArray)
        
        if(compatibility){
            
            
            var list_data: [Int] = []// binary data in message
            
            for j in 0 ..< raw_data.count {
                for k in 0...7 {
                    
                    let bit = k
                    let bitPlace = 7 - bit
                    let state: Int = Int((raw_data[j] >> UInt8(bitPlace)) & 0x01)
                    list_data.append(state)
                }
            }
            
            
            
            for i in 0 ..< (raw_data.count/8){
                
                
                
                for j in (96 + (8*i)) ..< ((96 + (8*i)) + 8) {
                    
                   for index in 1.stride(to: 7, by: 2) {
                    
                    let desByte = j
                    let bitState1 = Int((raw_data[i] >> UInt8(7-index)) & 0x01) // in bit 6 00000010
                    let bitState2 = Int((raw_data[i] >> UInt8(7-(index - 1))) & 0x01)  // in bit 7 00000001
                    let desBit1 = 7
                    let desBit2 = 6
                    let desiredBitPosition1 = 7 - desBit1
                    let desiredBitPosition2 = 7 - desBit2
                    
                    //print("before:\n\(String(byteArray[desByte],radix:2))")
                    
                    print("desired 1 \(desiredBitPosition1)")
                     print("desired 2 \(desiredBitPosition2)")
                    //byteArray[desByte] ^= (UInt8(-bitState1) ^ byteArray[desByte]) & UInt8(1 << desiredBitPosition1)
                    //byteArray[desByte] ^= (UInt8(-bitState2) ^ byteArray[desByte]) & UInt8(1 << desiredBitPosition2)
                    
                    //print("after:\n\(String(byteArray[desByte],radix:2))")
                    
                    } // end index
                    
                } // end j
                
                
            } // end i
            
            
            
            
        } else {
            
            
            
        }// end compatibility
        
        
        
        let decrypt: String? = cryptoClass().decryptDataAESText(ciphertext, user_password: password!)
        // print(decrypt!)
    }
    
    
    
    func checkMessageSizeFromString(message: [UInt8], picture: [UInt8]) -> Bool {
        
        let pic_size = picture.count
        let message_size = (message.count)
        
        if((pic_size - 96) > message_size*4) {
            return true
            
        } else {
            return false
        }
    }
    
    
    
}

