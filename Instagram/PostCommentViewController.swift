//
//  PostCommentViewController.swift
//  Instagram
//
//  Created by mimieden on 2017/07/02.
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class PostCommentViewController: UIViewController {

//==================================================
// グローバル変数/定数(課題)
//==================================================
//--(8.2)-------------------------------------------
    var V_Image: UIImage!
    var V_PostData: PostData!
    
//--Outlet(RestrationIDもセット!)(課題)---------------
    @IBOutlet weak var O_ImageView: UIImageView!
    @IBOutlet weak var O_Comment: UITextField!   

//==================================================
//  関数(ライフサイクル)
//==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画像をImageViewに設定する(8.2)
        O_ImageView.image = V_Image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//==================================================
//  関数(Action)(課題)
//==================================================
//--投稿ボタンをタップしたときに呼ばれるメソッド-------------
    @IBAction func A_PostComment(_ sender: Any) {
        
        //Firebaseに保存するデータの準備
        if (O_Comment.text?.isEmpty)! {               //コメント未記入の時は保存しない
            // HUDで未記入を通知する
            SVProgressHUD.showSuccess(withStatus: "コメントが記入されていません")
        } else {                          //コメントが入っていた場合 V_PostDataにデータが入っている
            
            V_PostData.V_Comment.append(O_Comment.text!)

            let l_Name = FIRAuth.auth()?.currentUser?.displayName
            V_PostData.V_CommentName.append(l_Name!)
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            V_PostData.V_CommentId.append(uid!)
            
            // 増えたComment/CommentName/CommentIdをFirebaseに保存する
            let l_PostRef = FIRDatabase.database().reference().child(Const.SL_PostPath).child(V_PostData.V_Id!)
            let l_Comment = ["comment": V_PostData.V_Comment]
            let l_CommentName = ["commentname": V_PostData.V_CommentName]
            let l_CommentId = ["commentid": V_PostData.V_CommentId]
            l_PostRef.updateChildValues(l_Comment)
            l_PostRef.updateChildValues(l_CommentName)
            l_PostRef.updateChildValues(l_CommentId)
            
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            
            // 全てのモーダルを閉じる
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
//--キャンセルボタンをタップしたときに呼ばれるメソッド--------
    @IBAction func A_CencelComment(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }
}
