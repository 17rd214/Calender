//
//  GraphViewController.swift
//  Calender
//
//  Created by masa.miura on 2020/06/25.


import UIKit
import Charts

class GraphViewController: UIViewController {
    
   @IBOutlet weak var pieChartsView: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var i = 0
        var n = 0
        var total_nitiyou = 0
        var total_goraku = 0

        // Do any additional setup after loading the view.
        
        while true {
            if(Savedata.save_string[i].year == Uke.now_year && Savedata.save_string[i].month == Uke.now_month) {
                break
            }
            i += 1
        }
        
        while n < 31{
            total_goraku += Savedata.save_string[i].keep_days_goraku[n]
            total_nitiyou += Savedata.save_string[i].keep_days_nitiyou[n]
            n += 1
        }
        
        // 円グラフの中心に表示するタイトル
        self.pieChartsView.centerText = "月の出費"
        
        // グラフに表示するデータのタイトルと値
        let dataEntries = [
            PieChartDataEntry(value: Double(total_goraku), label: "娯楽"),
            PieChartDataEntry(value: Double(total_nitiyou), label: "日用品"),
            PieChartDataEntry(value: Double(Savedata.save_string[i].special), label: "特別"),
            PieChartDataEntry(value: Double(Savedata.save_string[i].koteihi), label: "固定")
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: " ")

        // グラフの色
        dataSet.colors = ChartColorTemplates.vordiplom()
        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor.black
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor.black

        self.pieChartsView.data = PieChartData(dataSet: dataSet)
        
        // データを％表示にする
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        self.pieChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        self.pieChartsView.usePercentValuesEnabled = true
        
        view.addSubview(self.pieChartsView)
        
        
    }
    
    

}
