//
//  DistanceViewController.swift
//  Activity
//
//  Created by awal on 12/8/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//

import UIKit
import Charts
import MapKit
import CoreLocation

class DistanceViewController: UIViewController, ChartViewDelegate, CLLocationManagerDelegate {
    
    // Instance Variables
    let tzero: TimeInterval = Date().timeIntervalSince1970
    var sampleCounter = 0
    var lmDelegate = LocationDelegate()
    var locationManager: CLLocationManager = CLLocationManager()
    
    // Outlets
    @IBOutlet weak var distanceView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss"
        
        locationManager.delegate = lmDelegate
        if NSString(string: UIDevice.current.systemVersion).doubleValue > 8 {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.distanceView.delegate = self
        self.distanceView.chartDescription?.text = ""
        self.distanceView.chartDescription?.textColor = UIColor.white
        self.distanceView.gridBackgroundColor = UIColor.darkGray
        self.distanceView.noDataText = ""
        self.distanceView.xAxis.drawGridLinesEnabled = false
        self.distanceView.leftAxis.drawGridLinesEnabled = false
        self.distanceView.rightAxis.drawGridLinesEnabled = false
        self.distanceView.drawBordersEnabled = false
        self.distanceView.rightAxis.enabled = false
        self.distanceView.xAxis.labelPosition = .bottom
        self.distanceView.xAxis.valueFormatter = DefaultAxisValueFormatter { (value, axis) -> String in return dateFormatter.string(from: Date(timeIntervalSince1970: value)) }
        self.distanceView.setVisibleYRangeMinimum(Double(0), axis: distanceView.leftAxis.axisDependency)
        
        // Legend setup
        self.distanceView.legend.enabled = true
        let legend: Legend = self.distanceView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        
        // Create array of Chart Data Entries
        var initDataEntryArray2 : [ChartDataEntry] = [ChartDataEntry]()
        initDataEntryArray2.append(ChartDataEntry(x: Double(tzero), y: 0))
        
        // Initialize LineChart appearance and prepare data to be empty array at first
        let set2: LineChartDataSet = LineChartDataSet(values: initDataEntryArray2, label: "Miles")
        set2.mode = .horizontalBezier
        set2.axisDependency = .left
        set2.setColor(UIColor.blue.withAlphaComponent(0.5))
        set2.setCircleColor(UIColor.blue)
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.purple
        set2.highlightColor = UIColor.white
        set2.drawCircleHoleEnabled = true
        set2.drawCirclesEnabled = true
        set2.drawFilledEnabled = true
        set2.fillColor = UIColor.green
        
        // Create an array to store our LineChartDataSet(s)
        var dataSets2 : [LineChartDataSet] = [LineChartDataSet]()
        dataSets2.append(set2)
        
        // Create the data to give the LineChart
        
        let data2: LineChartData = LineChartData(dataSets: dataSets2)
        data2.setDrawValues(false) // whether to show values above points on graph
        
        // Now, set our data
        self.distanceView.data = data2
        
        // Begin timer that logs speeds
        let everyXseconds = 5.0
        var updateDistanceTimer = Timer.scheduledTimer(timeInterval: everyXseconds, target: self, selector: Selector("updateDistance"), userInfo: nil, repeats: true)
    }
    
    func updateDistance() {
        // // ** Main App Loop ** // //
        
        // Update distance traveled
        let distanceTraveled = lmDelegate.distanceTraveled
        let miles = distanceTraveled * 0.00062137
        let currentTime: TimeInterval = Date().timeIntervalSince1970
        let distanceEntry = ChartDataEntry(x: Double(currentTime), y: Double(miles))
        
        // Plot activityLevel over time in second Line Chart View
        self.distanceView.data?.addEntry(distanceEntry, dataSetIndex: 0)
        self.distanceView.notifyDataSetChanged()
        let moveToVal = max(Double(tzero), Double(currentTime) - 20.0)
        self.distanceView.moveViewToAnimated(xValue: moveToVal, yValue: miles, axis: self.distanceView.rightAxis.axisDependency, duration: TimeInterval(0.5))
        self.distanceView.setVisibleXRangeMaximum(20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
