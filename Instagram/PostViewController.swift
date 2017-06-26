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
    @IBAction func A_HandlePostButton(_ sender: Any) {
    }
    
    @IBAction func A_HandleCancelButton(_ sender: Any) {
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
