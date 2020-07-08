//
//  Savedata.swift
//  Calender
//
//  Created by masa.miura on 2020/06/19.
//

import Foundation

class Savedata{//データ保存をする場所
    struct Datasave {
         var keep_days_goraku = Array(repeating:0,count:31)
         var keep_days_nitiyou  = Array(repeating:0,count:31)
         var koteihi = 0
         var income = 0
         var special = 0
         var shokuhi = 0
         var year = 0
         var month = 0
    }
    static var save_string = [Datasave]()  //構造体の配列宣言
}
    
        
    

