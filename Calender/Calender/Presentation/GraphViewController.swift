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

        // Do any additional setup after loading the view.
        
        // 円グラフの中心に表示するタイトル
        self.pieChartsView.centerText = "テストデータ"
        
        // グラフに表示するデータのタイトルと値
        let dataEntries = [
            PieChartDataEntry(value: 40, label: "A"),
            PieChartDataEntry(value: 35, label: "B"),
            PieChartDataEntry(value: 25, label: "C")
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "テストデータ")

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
