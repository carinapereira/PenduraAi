//
//  ChartViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 05/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import Charts
import Firebase

class ChartViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    var ref:FIRDatabaseReference!
    var refShop:FIRDatabaseReference!
    var dataSelecionada = ""
    var months: [String]! =  ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Análise Gráfica"
        
        if let user = FIRAuth.auth()?.currentUser{
            var shopKey: String = ""
            refShop = FIRDatabase.database().reference().child("shop")
            refShop.queryOrdered(byChild: "userKey").queryEqual(toValue: user.uid).observeSingleEvent(of: .value, with:{(snapshot) in
                
                let enumerator = snapshot.children
                while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                    shopKey = item.key
                }
                
                if shopKey != "" {
                    self.ref = FIRDatabase.database().reference().child("shopClient")
                    self.startingObserveDB(shopKey: shopKey)
                }
            })
        }
    }
    
    func startingObserveDB(shopKey: String) {
        var jan = 0.0
        var fev = 0.0
        var mar = 0.0
        var abr = 0.0
        var mai = 0.0
        var jun = 0.0
        var jul = 0.0
        var ago = 0.0
        var set = 0.0
        var out = 0.0
        var nov = 0.0
        var dez = 0.0
        
        ref.queryOrdered(byChild: "shopKey").queryEqual(toValue: shopKey).observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let result = snapShot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    if let result2 = child.childSnapshot(forPath: "shopClientValue").children.allObjects as? [FIRDataSnapshot] {
                        for child2 in result2 {
                            var dic = child2.value as! [String: Any]
                            let day = dic["date"] as? String
                            
                            if let sum = dic["sum"] as? Bool {
                                if let valor = dic["value"] as? Double {
                                    if sum {
                                        if let dia = day {
                                            let dataMov = Date().toDate(data: dia)
                                            let mes = Date().month(data: dataMov)
                                            
                                            switch(mes){
                                            case 1:
                                                jan += valor
                                            case 2:
                                                fev += valor
                                            case 3:
                                                mar += valor
                                            case 4:
                                                abr += valor
                                            case 5:
                                                mai += valor
                                            case 6:
                                                jun += valor
                                            case 7:
                                                jul += valor
                                            case 8:
                                                ago += valor
                                            case 9:
                                                set += valor
                                            case 10:
                                                out += valor
                                            case 11:
                                                nov += valor
                                            default:
                                                dez += valor
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            let unitsSold = [jan, fev, mar, abr, mai, jun, jul, ago, set, out, nov, dez]
            self.setChart(dataPoints: self.months, values: unitsSold)
        })
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            //let dataEntry = BarChartDataEntry(x:values[i], yValues: [Double(i)], label: dataPoints[i])
            //let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
            
        }
        
        let xAxis=XAxis()
        let chartFormmater = BarChartFormatter()
        chartFormmater.setValues(values: dataPoints)
        
        xAxis.valueFormatter=chartFormmater
        barChartView.xAxis.valueFormatter=xAxis.valueFormatter
        
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Total de Vendas")
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        //let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
    }
   

}
