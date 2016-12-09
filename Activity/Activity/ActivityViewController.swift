//
//  ActivityLevelViewController.swift
//  Activity
//
//  Created by awal on 12/8/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//

import UIKit
import Charts
import MapKit
import CoreLocation
import CoreMotion
import Foundation
import Accelerate

class ActivityViewController: UIViewController, ChartViewDelegate {
    
    // Instance Variables
    let tzero: TimeInterval = Date().timeIntervalSince1970
    var movementManager = CMMotionManager()
    var livePointCounter = 0
    var sampleCounter = 0
    let ShowMaxPoints = 200
    let samplingPeriod = 0.04 // seconds
    let MaxSamples = 128
    var Samples = [Float](repeating: 0.0, count: 128)
    
    // Outlets
    @IBOutlet weak var levelView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss"
        
        self.levelView.delegate = self
        self.levelView.chartDescription?.text = ""
        self.levelView.chartDescription?.textColor = UIColor.white
        self.levelView.gridBackgroundColor = UIColor.darkGray
        self.levelView.noDataText = ""
        self.levelView.xAxis.drawGridLinesEnabled = false
        self.levelView.leftAxis.drawGridLinesEnabled = false
        self.levelView.rightAxis.drawGridLinesEnabled = false
        self.levelView.drawBordersEnabled = false
        self.levelView.rightAxis.enabled = false
        self.levelView.xAxis.labelPosition = .bottom
        self.levelView.xAxis.valueFormatter = DefaultAxisValueFormatter { (value, axis) -> String in return dateFormatter.string(from: Date(timeIntervalSince1970: value)) }
        self.levelView.setVisibleYRangeMinimum(Double(0), axis: levelView.leftAxis.axisDependency)
        
        // Legend setup
        self.levelView.legend.enabled = true
        let legend: Legend = self.levelView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        
        // Create array of Chart Data Entries
        var initDataEntryArray2 : [ChartDataEntry] = [ChartDataEntry]()
        initDataEntryArray2.append(ChartDataEntry(x: Double(tzero), y: 0))
        
        // Initialize LineChart appearance and prepare data to be empty array at first
        let set2: LineChartDataSet = LineChartDataSet(values: initDataEntryArray2, label: "Energy expenditure (%)")
        set2.mode = .horizontalBezier
        set2.axisDependency = .left
        set2.setColor(UIColor.blue.withAlphaComponent(0.5))
        set2.setCircleColor(UIColor.blue)
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.blue
        set2.highlightColor = UIColor.white
        set2.drawCircleHoleEnabled = true
        set2.drawCirclesEnabled = true
        set2.drawFilledEnabled = true
        set2.fillColor = UIColor.lightGray
        
        // Create an array to store our LineChartDataSet(s)
        var dataSets2 : [LineChartDataSet] = [LineChartDataSet]()
        dataSets2.append(set2)
        
        // Create the data to give the LineChart
        
        let data2: LineChartData = LineChartData(dataSets: dataSets2)
        data2.setDrawValues(false) // whether to show values above points on graph
        
        // Now, set our data
        self.levelView.data = data2
        
        // Finally, prepare accelerometer sensor data reading handling
        movementManager.accelerometerUpdateInterval = samplingPeriod
        
        //Start Recording Data
        movementManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            self.outputZAccData(acceleration: accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
    }
    
    
    func outputZAccData(acceleration: CMAcceleration) {
        // // ** Main App Loop ** // //
        
        let zAcc = acceleration.z

        
        //Add to Samples
        if sampleCounter < MaxSamples {
            Samples.insert(Float(zAcc), at: sampleCounter)
        }
        sampleCounter += 1
        
        if sampleCounter == MaxSamples {
            let activityLevel = getActivityLevel(samples: Samples)
            let currentTime: TimeInterval = Date().timeIntervalSince1970
            let activityLevelEntry = ChartDataEntry(x: Double(currentTime), y: Double(activityLevel))
            
            // Plot activityLevel over time in second Line Chart View
            self.levelView.data?.addEntry(activityLevelEntry, dataSetIndex: 0)
            self.levelView.notifyDataSetChanged()
            let moveToVal = max(Double(tzero), Double(currentTime) - 20.0)
            self.levelView.moveViewToAnimated(xValue: moveToVal, yValue: 0.5, axis: self.levelView.rightAxis.axisDependency, duration: TimeInterval(0.5))
            self.levelView.setVisibleXRangeMaximum(20)
            
            sampleCounter = 0 // reset counter
            Samples.removeAll(keepingCapacity: true)
            
            // Only update the speed label after we collect MaxSamples accel data.
        }
    }
    
    // Borrowed from Tempi-FFT application on Github
    @inline(__always) private func fastAverage(_ array:[Float], _ startIdx: Int, _ stopIdx: Int) -> Float {
        var mean: Float = 0
        let ptr = UnsafePointer<Float>(array)
        vDSP_meanv(ptr + startIdx, 1, &mean, UInt(stopIdx - startIdx))
        return mean
    }
    
    func getActivityLevel(samples: [Float]) -> Float {
        // Commputes variance of z accel data
        let avg = getAverage(samples: samples)
        return getAverage(samples: samples.map{pow($0 - avg, 2)})
    }
    
    func getAverage(samples: [Float]) -> Float {
        return fastAverage(samples, 0, samples.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

