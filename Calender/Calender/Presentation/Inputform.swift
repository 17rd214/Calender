//
//  Inputform.swift
//  Calender
//
//  Created by masa.miura on 2020/06/18.
//

import UIKit

class Inputform: UIViewController {

    
    
    @IBOutlet weak var Input_date: UITextField!
    
    
    @IBOutlet weak var Input_syuppi: UITextField!
    
    
    @IBAction func keep_gorakuhi(_ sender: Any) {
        Uke.goraku = Int(Input_syuppi.text!)!
        Uke.hiduke = Int(Input_date.text!)!
        Input_syuppi.text = "保存しました"
        //Thread.sleep(forTimeInterval: 1.0)
        Input_syuppi.text = ""
        
    }
    
    
    @IBAction func keep_nitiyohi(_ sender: Any) {
        Uke.nitiyo = Int(Input_syuppi.text!)!
        Uke.hiduke = Int(Input_date.text!)!
        Input_syuppi.text = "保存しました"
        //Thread.sleep(forTimeInterval: 1.0)
        Input_syuppi.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //キーボード変更(数字のみ)
        Input_date.keyboardType = UIKeyboardType.numberPad
        
        //キーボード変更(数字のみ)
        Input_syuppi.keyboardType = UIKeyboardType.numberPad
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //キーボードを閉じる
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
}
