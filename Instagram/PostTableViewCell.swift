//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by mimieden on 2017/06/27.
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
//==================================================
// グローバル変数/定数
//==================================================
//--Outlet(RestrationIDもセット!)(5.7)----------------
    @IBOutlet weak var O_PostImageView: UIImageView!
    @IBOutlet weak var O_LikeButton: UIButton!
    @IBOutlet weak var O_LikeLabel: UILabel!
    @IBOutlet weak var O_DateLabel: UILabel!
    @IBOutlet weak var O_CaptionLabel: UILabel!
   
//==================================================
// 関数
//==================================================
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func F_SetPostData(postData: PostData) {
        self.O_PostImageView.image = postData.V_Image
        
        self.O_CaptionLabel.text = "\(postData.V_Name!) : \(postData.V_Caption!)"
        let l_likeNumber = postData.V_Likes.count
        O_LikeLabel.text = "\(l_likeNumber)"
        
        let l_formatter = DateFormatter()
        l_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        l_formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = l_formatter.string(from: postData.V_Date! as Date)
        self.O_DateLabel.text = dateString
        
        if postData.V_IsLiked {
            let l_buttonImage = UIImage(named: "like_exist")
            self.O_LikeButton.setImage(l_buttonImage, for: UIControlState.normal)
        } else {
            let l_buttonImage = UIImage(named: "like_none")
            self.O_LikeButton.setImage(l_buttonImage, for: UIControlState.normal)
        }
    }
    
}

