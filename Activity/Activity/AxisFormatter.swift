//
//  AxisFormatter.swift
//  Activity
//
//  Created by awal on 12/9/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//
// Reference: https://github.com/danielgindi/Charts/issues/1688

import Foundation
import Charts

public class XAxisFormatter: NSObject, IAxisValueFormatter {
    
    var labels: [String]
    /// Called when a value from an axis is formatted before being drawn.
    ///
    /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
    ///
    /// - returns: The customized label that is drawn on the x-axis.
    /// - parameter value:           the value that is currently being drawn
    /// - parameter axis:            the axis that the value belongs to
    ///
    
    //swap the labels array with your x-axis-Strings
    init(labels: [String]) {
        self.labels = labels
    }
    
    
    // it will then use the stored labels as values for xaxis when the corr. index is pass as 'value'
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let valStr = labels[Int(value)]
        
        //do formatting
        // ...
        return valStr
    }
}
