//
//  DataGenerator.swift
//  Activity
//
//  Created by awal on 12/9/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//

import Foundation

struct Point {
    var label: String
    var value: Double
}

class DataGenerator {
    
    static var randomizedVal: Double {
        return Double(arc4random_uniform(1000) + 1) / 10
    }
    
    static func data(key: String) -> [Point] {
        var labels = [String]()
        switch key {
        case "week/speeds":
            labels = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]
        case "week/distances":
            labels = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]
        case "month/speeds":
            labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        case "month/distances":
            labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        case "year/speeds":
            labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        case "year/distances":
            labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        default:
            labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        }
        var points = [Point]()
        
        for label in labels {
            let point = Point(label: label, value: randomizedVal)
            points.append(point)
        }
        
        return points
    }
}
