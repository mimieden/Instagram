//
//  PostViewController.swift
//  Instagram
//
//  Created by mimieden on 2017/06/25.
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit
import Firebase          //(8.2)
import FirebaseDatabase  //(8.2)
import SVProgressHUD     //(8.2)

class PostViewController: UIViewController {

//==================================================
// グローバル変数/定数
//==================================================
//--(8.2)-------------------------------------------
    var V_Image: UIImage!
    
//--Outlet(RestrationIDもセット!)(8.1)----------------
    @IBOutlet weak var O_ImageView: UIImageView!
    @IBOutlet weak var O_TextField: UITextField!
  
//==================================================
//  関数(ライフサイクル)
//==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //受け取った画像をImageViewに設定する(8.2)
        O_ImageView.image = V_Image

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//==================================================
//  関数(Action)(8.1)
//==================================================
//--投稿ボタンをタップしたときに呼ばれるメソッド-------------
    @IBAction func A_HandlePostButton(_ sender: Any) {
        
        // ImageViewから画像を取得する
        let l_ImageData = UIImageJPEGRepresentation(O_ImageView.image!, 0.5)
        let l_ImageString = l_ImageData!.base64EncodedString(options: .lineLength64Characters)
        
        // postDataに必要な情報を取得しておく
        let l_Time = NSDate.timeIntervalSinceReferenceDate
        let l_Name = FIRAuth.auth()?.currentUser?.displayName
        
        // 辞書を作成してFirebaseに保存する
        let l_PostRef = FIRDatabase.database().reference().child(Const.SL_PostPath)
        let l_PostData = ["caption": O_TextField.text!, "image": l_ImageString, "time": String(l_Time), "name": l_Name!]
        l_PostRef.childByAutoId().setValue(l_PostData)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
//--キャンセルボタンをタップしたときに呼ばれるメソッド--------
    @IBAction func A_HandleCancelButton(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
