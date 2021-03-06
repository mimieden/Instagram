//
//  LoginViewController.swift
//  Instagram
//
//  Created by mimieden on 2017/06/25.
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit
import Firebase      //(5.7)
import FirebaseAuth  //(5.7)
import SVProgressHUD //(5.7)

class LoginViewController: UIViewController {

    
//==================================================
// グローバル変数/定数
//==================================================
//--Outlet(RestrationIDもセット!)(5.7)----------------
    @IBOutlet weak var O_MailAddressTextField: UITextField!
    @IBOutlet weak var O_PasswordTextField: UITextField!
    @IBOutlet weak var O_DisplayNameTextField: UITextField!

//==================================================
//  関数(ライフサイクル)
//==================================================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//==================================================
//  関数(Action)(5.7)
//==================================================
    // ログインボタンをタップしたときに呼ばれるメソッド
    @IBAction func A_HandleLoginButton(_ sender: Any) {
        if let l_Adress = O_MailAddressTextField.text, let l_password = O_PasswordTextField.text {
            //アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if l_Adress.characters.isEmpty || l_password.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")  //(5.7)
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            FIRAuth.auth()?.signIn(withEmail: l_Adress, password: l_password) { user, error in
                if let l_Error = error {
                    print("DEBUG_PRINT:" + l_Error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")  //(5.7)
                    return
                } else {
                    print("DEBUG_PRINT: ログインに成功しました")
                    
                    //HUDを消す
                    SVProgressHUD.dismiss()
                    
                    //画面を閉じてViewControllerに戻る
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    // アカウント作成ボタンをタップしたときに呼ばれるメソッド
    @IBAction func A_HandleCreateAcountButton(_ sender: Any) {
        if let l_Adress = O_MailAddressTextField.text, let l_password = O_PasswordTextField.text, let l_DisplayName = O_DisplayNameTextField.text {
            //アドレス/パスワード/表示名のいずれでも入力されていないときは何もしない
            if l_Adress.characters.isEmpty || l_password.characters.isEmpty || l_DisplayName.characters.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            //アドレス/パスワードでユーザー作成し、作成に成功すると自動的にログインする
            FIRAuth.auth()?.createUser(withEmail: l_Adress, password: l_password) { user, error in
                if let l_Error = error {
                    //エラーがあったら原因をprintしreturnすることで以降の処理を実行せずに処理を終了する@
                    print("DEBUG_PRINT:" + l_Error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    return
                }
            
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
       
                //表示名を設定する ??テキストではif let user = user その後のuserは何を使う？
                let l_UserC = FIRAuth.auth()?.currentUser
                if let l_User = l_UserC {
                    let l_ChangeRequest = l_User.profileChangeRequest()
                    l_ChangeRequest.displayName = l_DisplayName
                    l_ChangeRequest.commitChanges { error in
                        if let l_Error = error {
                            print("DEBUG_PRINT: " + l_Error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "ユーザー作成時にエラーが発生しました。")
                        }
                        print("DEBUG_PRINT: [displayName = \(l_User.displayName!)]の設定に成功しました。")
                        
                        //HUDを消す
                        SVProgressHUD.dismiss()
                        
                        //画面を閉じてViewControllerに戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("DEBUG_PRINT: displayNameの設定に失敗しました。")
                }
            }
        }
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
