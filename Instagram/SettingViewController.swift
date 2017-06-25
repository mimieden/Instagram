//
//  SettingViewController.swift
//  Instagram
//
//  Created by mimieden on 2017/06/25.
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit
import ESTabBarController  //(5.8)
import Firebase            //(5.8)
import FirebaseAuth        //(5.8)
import SVProgressHUD       //(5.8)

class SettingViewController: UIViewController {

//==================================================
// グローバル変数/定数
//==================================================
//--Outlet(RestrationIDもセット!)(5.7)----------------
    @IBOutlet weak var O_DisplayNameTextField: UITextField!
    
//==================================================
//  関数(ライフサイクル)
//==================================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //表示名を取得してTextFieldに設定する ??テキストではif let user = user その後のuserは何を使う？
        let l_UserC = FIRAuth.auth()?.currentUser
        if let l_User = l_UserC {
            O_DisplayNameTextField.text = l_User.displayName
        }
    }

//==================================================
//  関数(Action)(5.8)
//==================================================
//--表示名変更ボタンをタップしたときによばれるメソッド--------
    @IBAction func A_HandleChangeButton(_ sender: Any) {
        if let l_DisplayName = O_DisplayNameTextField.text {
            
            //表示名が入力されていないときはHUDを出して何もしない
            if l_DisplayName.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                return
            }
            
            //表示名を設定する
            let l_UserC = FIRAuth.auth()?.currentUser
            if let l_User = l_UserC {
                let l_Changerequest = l_User.profileChangeRequest()
                l_Changerequest.displayName = l_DisplayName
                l_Changerequest.commitChanges { error in
                    if let l_Error = error {
                        print("DEBUG_PRINT: " + l_Error.localizedDescription)
                    }
                    print("DEBUG_PRINT: [displayName = \(l_User.displayName!)]の設定に成功しました。")
                    
                    //HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            } else {
               print("DEBUG_PRINT: displayNameの設定に失敗しました。")
            }
        }
        //キーボードを閉じる
        self.view.endEditing(true)
    }
//--ログアウトボタンをタップしたときに呼ばれるメソッド--------
    @IBAction func A_HandleLogoutButton(_ sender: Any) {
        //ログアウトする
        try! FIRAuth.auth()?.signOut()
        
        //ログイン画面を表示する
        let l_LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(l_LoginViewController!, animated: true, completion: nil)
        
        //ログイン画面から戻ってきたときのためにホーム画面(index = 0)を選択している状態にしておく
        let l_TabBarController = parent as! ESTabBarController
        l_TabBarController.setSelectedIndex(0, animated: false)
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
