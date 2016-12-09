//
//  ActivityLevelViewController.swift
//  Activity
//
//  Created by awal on 12/8/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//
// Reference: https://github.com/danielgindi/Charts

import UIKit
import Charts
import CoreMotion
import Foundation
import Accelerate

class LiveViewController: UIViewController, ChartViewDelegate {
    

    // Instance Variables
    let tzero: TimeInterval = Date().timeIntervalSince1970
    var movementManager = CMMotionManager()
    var livePointCounter = 0
    var sampleCounter = 0
    let ShowMaxPoints = 200
    let samplingPeriod = 0.04 // seconds
    
    // Outlets
    @IBOutlet weak var liveView: LineChartView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let convertedDate = dateFormatter.string(from: currentDate as Date)
        dateLabel.text = convertedDate
        
        self.liveView.delegate = self
        self.liveView.chartDescription?.text = ""
        self.liveView.chartDescription?.textColor = UIColor.white
        self.liveView.gridBackgroundColor = UIColor.darkGray
        self.liveView.noDataText = ""
        self.liveView.xAxis.drawGridLinesEnabled = false
        self.liveView.xAxis.drawLabelsEnabled = false
        self.liveView.leftAxis.drawGridLinesEnabled = false
        self.liveView.rightAxis.drawGridLinesEnabled = false
        self.liveView.drawBordersEnabled = false
        self.liveView.xAxis.drawAxisLineEnabled = false
        self.liveView.rightAxis.enabled = false
        self.liveView.leftAxis.enabled = false
        self.liveView.legend.enabled = false
        
        // Create array of Chart Data Entries
        var initDataEntryArray : [ChartDataEntry] = [ChartDataEntry]()

        
        initDataEntryArray.append(ChartDataEntry(x: 0, y: -1)) // if no entry, then get out of bounds error.
        
        // Initialize LineChart appearance and prepare data to be empty array at first
        let set1: LineChartDataSet = LineChartDataSet(values: initDataEntryArray, label: "Live")
        set1.axisDependency = .left
        set1.setColor(UIColor.red.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.red)
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = false
        set1.drawCirclesEnabled = false
        
        // Create an array to store our LineChartDataSet(s)
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        // Create the data to give the LineChart
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setDrawValues(false) // do not show values above points on graph
        
        // Now, set our data
        self.liveView.data = data

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
        if livePointCounter == 0 {
            // remove initial dummy entry
            self.liveView.data?.removeEntry(xValue: Double(0), dataSetIndex: 0)
        }
        
        let zAccEntry = ChartDataEntry(x: Double(livePointCounter), y: zAcc)
        self.liveView.data?.addEntry(zAccEntry, dataSetIndex: 0)
        self.liveView.notifyDataSetChanged()
        livePointCounter += 1
        
        // Shifts the view over time (show ShowMaxPoints)
        self.liveView.xAxis.axisMinimum = Double(max(0, livePointCounter - ShowMaxPoints))
        
        // Also only keep ShowMaxPoints in dataset
        if livePointCounter >= ShowMaxPoints {
            self.liveView.data?.removeEntry(xValue: Double(livePointCounter - ShowMaxPoints), dataSetIndex: 0)
        }
    }
    
    // Borrowed from Tempi-FFT application on Github
    @inline(__always) private func fastAverage(_ array:[Float], _ startIdx: Int, _ stopIdx: Int) -> Float {
        var mean: Float = 0
        let ptr = UnsafePointer<Float>(array)
        vDSP_meanv(ptr + startIdx, 1, &mean, UInt(stopIdx - startIdx))
        return mean
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
