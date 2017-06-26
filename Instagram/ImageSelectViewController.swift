//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by mimieden on 2017/06/25.
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit

//デリゲート追加(6.2)
class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
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
//  関数(Action)(6.2)
//==================================================
    @IBAction func A_HandleLibraryButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let l_PickerController = UIImagePickerController()
            l_PickerController.delegate = self
            l_PickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(l_PickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func A_HandleCameraButton(_ sender: Any) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let l_pickerController = UIImagePickerController()
            l_pickerController.delegate = self
            l_pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(l_pickerController, animated: true, completion: nil)
        }
    }
        
    @IBAction func A_HandleCancelButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }

//==================================================
//  関数（その他）
//==================================================
    // 写真を撮影/選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像を取得する
            let l_Image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // あとでAdobeUXImageEditorを起動する
        }
        
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
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
