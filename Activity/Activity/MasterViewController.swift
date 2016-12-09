//
//  ViewController.swift
//  Activity
//
//  Created by awal on 12/8/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//
// Reference: https://cocoacasts.com/managing-view-controllers-with-container-view-controllers/

import UIKit

final class MasterViewController: UIViewController {

    // 1 Segmented Control Setup (Uses navigation bar)
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupSegmentedControl()
        updateView()
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Live", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Activity", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Speed", at: 2, animated: false)
        segmentedControl.insertSegment(withTitle: "Distance", at: 3, animated: false)

        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }

    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    // 2 ** Lazy View Controller Properties **
    private lazy var liveViewController : LiveViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "LiveViewController") as! LiveViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    private lazy var activityViewController : ActivityViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var speedViewController : SpeedViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "SpeedViewController") as! SpeedViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var distanceViewController : DistanceViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "DistanceViewController") as! DistanceViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()

    // 3 Add Child View Controllers
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    // 4 Removing VCs
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    // 5 Switching to Different Child VCs
    private func updateView() {
        // Removal of VC oes not deallocate VC because
        // MasterVC keeps reference (lazy) of each VC
        // (hence, VC keeps its state when not visible).
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            remove(asChildViewController: activityViewController)
            remove(asChildViewController: speedViewController)
            remove(asChildViewController: distanceViewController)
            add(asChildViewController: liveViewController)
        case 1:
            remove(asChildViewController: liveViewController)
            remove(asChildViewController: speedViewController)
            remove(asChildViewController: distanceViewController)
            add(asChildViewController: activityViewController)
        case 2:
            remove(asChildViewController: liveViewController)
            remove(asChildViewController: activityViewController)
            remove(asChildViewController: distanceViewController)
            add(asChildViewController: speedViewController)
        case 3:
            remove(asChildViewController: liveViewController)
            remove(asChildViewController: activityViewController)
            remove(asChildViewController: speedViewController)
            add(asChildViewController: distanceViewController)
        default:
            print("reached default")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

