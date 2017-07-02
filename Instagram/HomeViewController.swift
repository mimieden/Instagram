//
//  HomeViewController.swift
//  Instagram
//
//  Created by mimieden on 2017/06/25.
//  Copyright © 2017年 mimieden. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var O_TableView: UITableView!
    var V_Image: UIImage!
    var V_PostArray: [PostData] = []
    
    //FIRDatabaseのobserveEventの登録状態を表す
    var V_Observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        O_TableView.delegate = self
        O_TableView.dataSource = self
        
        // テーブルセルのタップを無効にする
        O_TableView.allowsSelection = false
        
        let l_Nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        O_TableView.register(l_Nib, forCellReuseIdentifier: "Cell")
        O_TableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if FIRAuth.auth()?.currentUser != nil {
            if self.V_Observing == false {
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let l_PostsRef = FIRDatabase.database().reference().child(Const.SL_PostPath)
                l_PostsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let l_Uid = FIRAuth.auth()?.currentUser?.uid {
                        let l_PostData = PostData(snapshot: snapshot, myID: l_Uid)
                        self.V_PostArray.insert(l_PostData, at: 0)
                        
                        // TableViewを再表示する
                        self.O_TableView.reloadData()
                    }
                })
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                l_PostsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let l_Uid = FIRAuth.auth()?.currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let l_PostData = PostData(snapshot: snapshot, myID: l_Uid)
                        
                        // 保持している配列からidが同じものを探す
                        var v_Index: Int = 0
                        for post in self.V_PostArray {
                            if post.V_Id == l_PostData.V_Id {
                                v_Index = self.V_PostArray.index(of: post)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.V_PostArray.remove(at: v_Index)
                        
                        // 削除したところに更新済みのでデータを追加する
                        self.V_PostArray.insert(l_PostData, at: v_Index)
                        
                        // TableViewの現在表示されているセルを更新する
                        self.O_TableView.reloadData()
                    }
                })
                
                // FIRDatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                V_Observing = true
            }
        } else {
            if V_Observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                V_PostArray = []
                O_TableView.reloadData()
                // オブザーバーを削除する
                FIRDatabase.database().reference().removeAllObservers()
                
                // FIRDatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                V_Observing = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return V_PostArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let l_Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        l_Cell.F_SetPostData(postData: V_PostArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        l_Cell.O_LikeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)
        
        // コメントボタンのアクションを設定する(課題)
        l_Cell.O_CommentButton.addTarget(self, action:#selector(handleComment(sender:event:)), for:  UIControlEvents.touchUpInside)
        
        return l_Cell
    }
    
    
    // コメントボタンがタップされた時に呼ばれるメソッド(課題)
    func handleComment(sender: UIButton, event:UIEvent) {
        print("DEBUG_PRINT: Commentボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let l_Touch = event.allTouches?.first
        let l_Point = l_Touch!.location(in: self.O_TableView)
        let l_IndexPath = O_TableView.indexPathForRow(at: l_Point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let l_PostData = V_PostArray[l_IndexPath!.row]
        
        // 画像をセット
        V_Image = l_PostData.V_Image

        //ボタンが押されたらPostCommentViewControllerをモーダルで表示する(課題)
        let l_PostCommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment")
        self.present(l_PostCommentViewController!, animated: true, completion: nil)
    }
    
    // セル内のボタンがタップされた時に呼ばれるメソッド
    func handleButton(sender: UIButton, event:UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let l_Touch = event.allTouches?.first
        let l_Point = l_Touch!.location(in: self.O_TableView)
        let l_IndexPath = O_TableView.indexPathForRow(at: l_Point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let l_PostData = V_PostArray[l_IndexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if l_PostData.V_IsLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in l_PostData.V_Likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = l_PostData.V_Likes.index(of: likeId)!
                        break
                    }
                }
                l_PostData.V_Likes.remove(at: index)
            } else {
                l_PostData.V_Likes.append(uid)
            }
            // 増えたlikesをFirebaseに保存する
            let l_PostRef = FIRDatabase.database().reference().child(Const.SL_PostPath).child(l_PostData.V_Id!)
            let l_Likes = ["likes": l_PostData.V_Likes]
            l_PostRef.updateChildValues(l_Likes)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutを使ってセルの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルをタップされたら何もせずに選択状態を解除する
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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
