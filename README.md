# Activity
## Alex Walczak

## A neat activity level tracking app.

Activity is a simplified movement tracker. It takes advantage of the iPhone's many sensors to tell you about your activity level.

<img src="https://raw.githubusercontent.com/alexwal/ios-decal-final-pro/master/screen0.PNG" align="left" height="178" width="100" >
<img src="https://raw.githubusercontent.com/alexwal/ios-decal-final-pro/master/screen1.PNG" align="left" height="178" width="100" >
<img src="https://raw.githubusercontent.com/alexwal/ios-decal-final-pro/master/screen2.PNG" align="left" height="178" width="100" >
<img src="https://raw.githubusercontent.com/alexwal/ios-decal-final-pro/master/screen3.PNG" align="left" height="178" width="100" >

## Features
* Live activity report card whenever you open the app.
* Accelerometer data from Core Motion used to compute energy expenditure.
* Speed data from Core Location and MapKit.
* Distance data from Core Location and MapKit.
* View all of the above over different periods of time.

## Control Flow
* The user first is presented with his/her live activity report card.
* This shows a live chart of instantaneous energy expenditure.
* Next, there is a way to navigate to distance, speed, and activity level for today.
* Also, all of the above can be viewed for the current week, month, and year.
* Additionally, averages are shown for each dataset.
* The above are all visually presented with live line and bar charts.

## Implementation

### Model
* AxisFormatter.Swift
* DataGenerator.Swift
* LocationDelegate.Swift

### View:
* Charts 3rd party package for plotting
* Main.Storyboard

### Controller:
* MasterViewController.Swift
* LiveViewController.Swfit
* ActivityViewController.Swift
* SpeedViewController.Swift
* DistanceViewController.Swift
* (one of the above controllers for each of day, week, month, year)
