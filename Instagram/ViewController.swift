//
//  ViewController.swift
//  Instagram
//
//  Created by mimieden on 2017/06/25.
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit
import ESTabBarController  //ESTabBarControllerの初期設定(4.2)
import Firebase            //(5.6)
import FirebaseAuth        //(5.6)

class ViewController: UIViewController {

//==================================================
// 関数（ライフサイクル）
//==================================================
//--ViewDidLoad-------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ESTabBarControllerのSセットアップ(4.2)
        F_SetupTab()
    }
    
//--ViewDidAplear(5.6)------------------------------
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //currentUser == nil =>ログインしていない
        if FIRAuth.auth()?.currentUser == nil {
            //ログイン画面を呼び出す
            //viewDidAppear内でpresent()を呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let l_LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(l_LoginViewController!, animated: true, completion: nil)
            }
        }
    }

//==================================================
// 関数（その他）
//==================================================
//--ESTabBarControllerのセットアップ(4.2)--------------
    func F_SetupTab() {
        
        //画像のファイル名を指定してESTabBarControllerを作成する
        let l_TabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        //背景色、選択時の色を設定する
        l_TabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        l_TabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)

        //作成したESTabBarControllerを親のViewController(=self)に追加する
        addChildViewController(l_TabBarController)                  //didMove:toParentViewControllerとセットで使う/追加するViewControllerを指定
        view.addSubview(l_TabBarController.view)                    // |-子のViewControllerのViewを追加
        l_TabBarController.view.frame = view.bounds                 // |-そのViewのframeを親のViewControllerのViewと同じ値にする
        l_TabBarController.didMove(toParentViewController: self)    //addChildViewControllerとセットで使う/指定の完了
        
        //タブをタップした時に表示するViewControllerを設定する
        let l_HomeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let l_SettingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        l_TabBarController.setView(l_HomeViewController, at: 0)
        l_TabBarController.setView(l_SettingViewController, at: 2)
        
        //真ん中のタブはボタンとして使う
        l_TabBarController.highlightButton(at: 1)
        l_TabBarController.setAction({
            //ボタンが押されたらImageViewControllerをモーダルで表示する
            let l_ImageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(l_ImageViewController!, animated: true, completion: nil)
        }, at: 1)
    }
}

