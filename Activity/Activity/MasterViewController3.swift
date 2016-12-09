//
//  ViewController.swift
//  Activity
//
//  Created by awal on 12/8/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//

import UIKit

final class MasterViewController3: UIViewController {
    
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
        segmentedControl.insertSegment(withTitle: "Activity", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Distance", at: 1, animated: false)
        
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    // 2 ** Lazy View Controller Properties **
    
    private lazy var activityViewController : ActivityViewController3 = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ActivityViewController3") as! ActivityViewController3
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var distanceViewController : DistanceViewController3 = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "DistanceViewController3") as! DistanceViewController3
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
            remove(asChildViewController: distanceViewController)
            add(asChildViewController: activityViewController)
        case 1:
            remove(asChildViewController: activityViewController)
            add(asChildViewController: distanceViewController)
        default:
            print("reached default")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

