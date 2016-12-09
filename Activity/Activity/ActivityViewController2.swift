//
//  ActivityLevelViewController2.swift
//  Activity
//
//  Created by awal on 12/8/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//
// Reference: http://www.thedroidsonroids.com/blog/ios/beautiful-charts-swift/

import UIKit
import Charts

class ActivityViewController2: UIViewController, ChartViewDelegate {

    @IBOutlet weak var activityView: BarChartView!
    @IBOutlet weak var averageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get and prepare the data
        let points = DataGenerator.data(key: "week/distances")
        
        // Customization
        activityView.descriptionText = ""
        activityView.xAxis.labelPosition = .bottom
        activityView.xAxis.setLabelCount(points.count, force: true)
        activityView.leftAxis.axisMinValue = 0.0
        activityView.leftAxis.axisMaxValue = 105.0
        activityView.rightAxis.enabled = false
        activityView.xAxis.drawGridLinesEnabled = false
        activityView.legend.enabled = false
        activityView.doubleTapToZoomEnabled = false
        activityView.highlighter = nil
        
        // Initialize an array to store chart data entries (values; y axis)
        var pointsEntries = [ChartDataEntry]()
        
        // Initialize an array to store labels (labels; x axis)
        var labels = [String]()
        
        var i = 0
        var avg = 0.0
        for point in points {
            // Create single chart data entry and append it to the array
            avg += point.value
            let pointEntry = BarChartDataEntry(x: Double(i), y: point.value)
            pointsEntries.append(pointEntry)
            
            // Append the label to the array
            labels.append(point.label)
            i += 1
        }
        avg = avg / Double(points.count)
        averageLabel.text = String(format: "%.2f %%", avg)
        
        // ** Prepare x-axis **
        let axisFormatter = XAxisFormatter(labels: labels)
        activityView.xAxis.granularity = 1
        activityView.xAxis.labelCount = labels.count
        activityView.xAxis.drawGridLinesEnabled = false
        activityView.drawValueAboveBarEnabled = true
        activityView.xAxis.valueFormatter = axisFormatter
        // ** End prepare x-axis **
        
        // Create bar chart data set containing pointsEntries
        let chartDataSet = BarChartDataSet(values: pointsEntries, label: "Profit22")
        chartDataSet.colors = ChartColorTemplates.joyful()
        
        
        // Create bar chart data with data set and array with values for x axis
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        // Set bar chart data to previously created data
        activityView.data = chartData
        
        // Animation
        activityView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
}
