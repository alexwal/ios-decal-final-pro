//
//  SpeedViewController.swift
//  Activity
//
//  Created by awal on 12/8/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//

import UIKit
import Charts
import MapKit
import CoreLocation

class SpeedViewController: UIViewController, ChartViewDelegate, CLLocationManagerDelegate {

    // Instance Variables
    let tzero: TimeInterval = Date().timeIntervalSince1970
    var sampleCounter = 0
    var lmDelegate = LocationDelegate()
    var locationManager: CLLocationManager = CLLocationManager()
    
    // Outlets
    @IBOutlet weak var speedView: LineChartView!
    
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
        
        self.speedView.delegate = self
        self.speedView.chartDescription?.text = ""
        self.speedView.chartDescription?.textColor = UIColor.white
        self.speedView.gridBackgroundColor = UIColor.darkGray
        self.speedView.noDataText = ""
        self.speedView.xAxis.drawGridLinesEnabled = false
        self.speedView.leftAxis.drawGridLinesEnabled = false
        self.speedView.rightAxis.drawGridLinesEnabled = false
        self.speedView.drawBordersEnabled = false
        self.speedView.rightAxis.enabled = false
        self.speedView.xAxis.labelPosition = .bottom
        self.speedView.xAxis.valueFormatter = DefaultAxisValueFormatter { (value, axis) -> String in return dateFormatter.string(from: Date(timeIntervalSince1970: value)) }
        self.speedView.setVisibleYRangeMinimum(Double(0), axis: speedView.leftAxis.axisDependency)
        
        // Legend setup
        self.speedView.legend.enabled = true
        let legend: Legend = self.speedView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
    
        // Create array of Chart Data Entries
        var initDataEntryArray2 : [ChartDataEntry] = [ChartDataEntry]()
        initDataEntryArray2.append(ChartDataEntry(x: Double(tzero), y: 0))
        
        // Initialize LineChart appearance and prepare data to be empty array at first
        let set2: LineChartDataSet = LineChartDataSet(values: initDataEntryArray2, label: "Miles per hour")
        set2.mode = .horizontalBezier
        set2.axisDependency = .left
        set2.setColor(UIColor.blue.withAlphaComponent(0.5))
        set2.setCircleColor(UIColor.blue)
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.green
        set2.highlightColor = UIColor.white
        set2.drawCircleHoleEnabled = true
        set2.drawCirclesEnabled = true
        set2.drawFilledEnabled = true
        set2.fillColor = UIColor.brown
        
        // Create an array to store our LineChartDataSet(s)
        var dataSets2 : [LineChartDataSet] = [LineChartDataSet]()
        dataSets2.append(set2)
        
        // Create the data to give the LineChart
        
        let data2: LineChartData = LineChartData(dataSets: dataSets2)
        data2.setDrawValues(false) // whether to show values above points on graph
        
        // Now, set our data
        self.speedView.data = data2

        // Begin timer that logs speeds
        let everyXseconds = 5.0
        var updateSpeedTimer = Timer.scheduledTimer(timeInterval: everyXseconds, target: self, selector: Selector("updateSpeed"), userInfo: nil, repeats: true)
    }
    
    func updateSpeed() {
        // // ** Main App Loop ** // //
        
        //Add to Samples
        sampleCounter += 1
        // Only update the speed label after we collect MaxSamples accel data.
        let speedToMPH = (lmDelegate.speed * 2.23694)
        
        let currentTime: TimeInterval = Date().timeIntervalSince1970
        let speedEntry = ChartDataEntry(x: Double(currentTime), y: Double(speedToMPH))
        
        // Plot activityLevel over time in second Line Chart View
        self.speedView.data?.addEntry(speedEntry, dataSetIndex: 0)
        self.speedView.notifyDataSetChanged()
        let moveToVal = max(Double(tzero), Double(currentTime) - 20.0)
        self.speedView.moveViewToAnimated(xValue: moveToVal, yValue: 0.5, axis: self.speedView.rightAxis.axisDependency, duration: TimeInterval(0.5))
        self.speedView.setVisibleXRangeMaximum(20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

