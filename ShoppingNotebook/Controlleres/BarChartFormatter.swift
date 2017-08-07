//
//  BarChartFormatter.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 05/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import Foundation
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter
{
    
    var names = [String]()
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return names[Int(value)]
    }
    
    public func setValues(values: [String])
    {
        self.names = values
    }
}

