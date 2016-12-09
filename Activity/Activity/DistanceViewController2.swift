//
//  ActivityLevelViewController2.swift
//  Activity
//
//  Created by awal on 12/8/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//

import UIKit
import Charts

class DistanceViewController2: UIViewController, ChartViewDelegate {

    @IBOutlet weak var distanceView: BarChartView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customization
        distanceView.descriptionText = ""
        distanceView.xAxis.labelPosition = .bottom
        distanceView.xAxis.setLabelCount(7, force: true)
        distanceView.leftAxis.axisMinValue = 0.0
        distanceView.leftAxis.axisMaxValue = 12.0
        distanceView.rightAxis.enabled = false
        distanceView.xAxis.drawGridLinesEnabled = false
        distanceView.legend.enabled = false
        distanceView.doubleTapToZoomEnabled = false
        distanceView.highlighter = nil
        
        // Get and prepare the data
        let points = DataGenerator.data(key: "week/distances")
        
        // Initialize an array to store chart data entries (values; y axis)
        var pointsEntries = [ChartDataEntry]()
        
        // Initialize an array to store labels (labels; x axis)
        var labels = [String]()
        
        var i = 0
        var total = 0.0
        for point in points {
            // Create single chart data entry and append it to the array
            total += point.value
            let pointEntry = BarChartDataEntry(x: Double(i), y: point.value/10.0)
            pointsEntries.append(pointEntry)
            
            // Append the label to the array
            labels.append(point.label)
            i += 1
        }
        totalLabel.text = String(format: "%.2f", total/10.0)
        
        // ** Prepare x-axis **
        let axisFormatter = XAxisFormatter(labels: labels)
        distanceView.xAxis.granularity = 1
        distanceView.xAxis.labelCount = labels.count
        distanceView.xAxis.drawGridLinesEnabled = false
        distanceView.drawValueAboveBarEnabled = true
        distanceView.xAxis.valueFormatter = axisFormatter
        // ** End prepare x-axis **
        
        // Create bar chart data set containing pointsEntries
        let chartDataSet = BarChartDataSet(values: pointsEntries, label: "ProfitZ")
        chartDataSet.colors = ChartColorTemplates.joyful()

        
        // Create bar chart data with data set and array with values for x axis
        let chartData = BarChartData(dataSets: [chartDataSet])
        
        // Set bar chart data to previously created data
        distanceView.data = chartData
        
        // Animation
        distanceView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        distanceView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
}
