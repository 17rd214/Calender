//
//  Inputform.swift
//  Calender
//
//  Created by masa.miura on 2020/06/18.
//

import UIKit

class Inputform: UIViewController {

    
    var days_select: Int?
    
    
    @IBOutlet weak var Input_date: UITextField!
    
    
    @IBOutlet weak var Input_syuppi: UITextField!
    
    //ボタンを押したら保存
    @IBAction func keep_gorakuhi(_ sender: Any) {
        Input_check()//中身の有無確認
        Uke.goraku = Int(Input_syuppi.text!)!
        Uke.hiduke = Int(Input_date.text!)!
        //Input_syuppi.text = "保存しました"
        //Thread.sleep(forTimeInterval: 1.0)
        Input_syuppi.text = ""
        
    }
    
    //ボタンを押したら保存
    @IBAction func keep_nitiyohi(_ sender: Any) {
        Input_check()//中身の有無確認
        Uke.nitiyo = Int(Input_syuppi.text!)!
        Uke.hiduke = Int(Input_date.text!)!
        //Input_syuppi.text = "保存しました"
        //Thread.sleep(forTimeInterval: 1.0)
        Input_syuppi.text = ""
    }
    
    

    @IBAction func kotei(_ sender: Any) {
        Input_check()
        Uke.koteihi = Int(Input_syuppi.text!)!
        //日付保存なし
        Input_syuppi.text = ""
    }
    

    @IBAction func income(_ sender: Any) {
        Input_check()
        //Uke.hiduke = Int(Input_date.text!)!
        Uke.income = Int(Input_syuppi.text!)!
        //日付保存なし
        Input_syuppi.text = ""
    }
    

    @IBAction func special(_ sender: Any) {
        Input_check()
        Uke.special = Int(Input_syuppi.text!)!
        //日付保存なし
        Input_syuppi.text = ""
    }
    
    
    @IBAction func shoku(_ sender: Any) {
        Input_check()
        Uke.shokuhi = Int(Input_syuppi.text!)!
        Input_syuppi.text = ""
    }
    
    
    //中身の有無確認
    func Input_check(){
        if(Input_date.text == ""){
            Input_date.text = String(0)
        }
        if(Input_syuppi.text == ""){
            Input_syuppi.text = String(0)
        }
        return
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Input_date.text = String(days_select!)
        
        //キーボード変更(数字のみ)
        Input_date.keyboardType = UIKeyboardType.numberPad
        
        //キーボード変更(数字のみ)
        Input_syuppi.keyboardType = UIKeyboardType.numberPad
    }
    

    
    //キーボードを閉じる
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
}
