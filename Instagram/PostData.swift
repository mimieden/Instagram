//
//  PostData.swift
//  Instagram
//
//  Created by mimieden on 2017/06/27. (9.1)
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var V_Id: String?
    var V_Image: UIImage?
    var V_ImageString: String?
    var V_Name: String?
    var V_Caption: String?
    var V_Date: NSDate?
    var V_Likes: [String] = []
    var V_IsLiked: Bool = false
    
    init(snapshot: FIRDataSnapshot, myID: String) {
        self.V_Id = snapshot.key
        
        let l_ValueDictionary = snapshot.value as! [String: AnyObject]
        
        V_ImageString = l_ValueDictionary["image"] as? String
        V_Image = UIImage(data: NSData(base64Encoded: V_ImageString!, options: .ignoreUnknownCharacters)! as Data)
        
        self.V_Name = l_ValueDictionary["name"] as? String
        
        self.V_Caption = l_ValueDictionary["caption"] as? String
        
        let l_Time = l_ValueDictionary["time"] as? String
        self.V_Date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(l_Time!)!)
        
        if let l_Likes = l_ValueDictionary["likes"] as? [String] {
            self.V_Likes = l_Likes
        }
        
        for V_IsLiked in self.V_Likes {
            if V_IsLiked == myID {
                self.V_IsLiked = true
                break
            }
        }
    }
}
