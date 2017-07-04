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
    @IBOutlet weak var O_CommentButton: UIButton!  //(課題)
    @IBOutlet weak var O_CommentLabel: UILabel!    //(課題)
    @IBOutlet weak var O_CommentNumber: UILabel!
    
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
        O_LikeLabel.text = "いいね \(l_likeNumber)件"
        
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
//--------コメント表示(課題)ここから----------------
        O_CommentLabel?.text = ""                             //コメント欄(表示)を一度クリアする
        let l_CommentNumber = postData.V_Comment.count        //コメント数(DB)を取得する
        
        O_CommentNumber.text = "コメント \(l_CommentNumber)件"        //コメント数を表示
        
        //コメント数(DB)が0の場合
        if l_CommentNumber == 0 {
            O_CommentLabel.isHidden = true                    //コメントラベルを非表示に
            //コメント数(DB)が1つ以上の場合
        } else {
            O_CommentLabel.isHidden = false                   //コメントラベルを表示に
            var v_CommentAll: String = ""                     //コメントラベル出力用変数
            
            //コメント1つ1つについてコメントラベル表示内容を編集
            for i in (1 ... l_CommentNumber) {
                //コメント毎にコメントしたユーザー名 + コメントを編集
                let l_CommentText:String = "\(postData.V_CommentName[i - 1]) : \(postData.V_Comment[i - 1])"
                //コメントが1つ目の場合、編集したテキストをコメントラベル出力用変数にセット
                if i == 1 {
                    v_CommentAll = "\(l_CommentText)"
                    //コメントが2つ目以降の場合、編集したテキストをコメントラベル出力用変数に追加
                } else {
                    v_CommentAll = "\(v_CommentAll) \n\(l_CommentText)"
                }
                //print(self.O_CommentLabel.text)
            }
            //コメントラベル出力用変数をコメントラベルにセット
            O_CommentLabel.text = v_CommentAll
        }
//--------コメント表示(課題)ここまで----------------
    }
}

