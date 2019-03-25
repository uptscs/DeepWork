//
//  TemplatesViewController.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/6/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
import FloatingPanel

class TemplatesViewController: UIViewController, FloatingPanelControllerDelegate {
    
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var btnSplits: UIButton!
    @IBOutlet weak var lblIntervalCount: UILabel!
    
    var fpController: FloatingPanelController!
    let contentVC = SelectionOptionViewController()
    var selectedHour = "Select"{
        didSet{
            self.btnHours.setTitle(selectedHour, for: .normal)
        }
    }
    var selectedMinute = "Select"{
        didSet{
            self.btnSplits.setTitle(selectedMinute, for: .normal)
        }
    }
    let hours = [".5 Hours", "1 Hour", "2 Hours", "3 Hours", "5 Hours", "8 Hours", "10 Hours", "12 Hours", "24 Hours"]
    let splits = ["5 Minutes","10 Minutes", "15 Minutes", "20 Minutes", "30 Minutes", "45 Minutes", "1 Hour"]
    
    fileprivate func converHourToMinutes(_ hour: String) -> Int{
        var minutes = 0
        switch hour {
            case ".5 Hours":
                minutes = 30
            case "1 Hour":
                minutes = 60
            case "2 Hours":
                minutes = 120
            case "3 Hours":
                minutes = 180
            case "5 Hours":
                minutes = 300
            case "8 Hours":
                minutes = 480
            case "10 Hours":
                minutes = 600
            case "12 Hours":
                minutes = 720
            case "24 Hours":
                minutes = 1440
            default:
                minutes = 0
        }
        return minutes;
    }
    
    fileprivate func convertMinuteStringToMinuteInt(_ minutesString: String) -> Int{
        var minutes = 0
        switch minutesString {
            case "5 Minutes":
                minutes = 5
            case "10 Minutes":
                minutes = 10
            case "15 Minutes":
                minutes = 15
            case "20 Minutes":
                minutes = 20
            case "30 Minutes":
                minutes = 30
            case "45 Minutes":
                minutes = 45
            case "1 Hour":
                minutes = 60
            default:
                minutes = 0
        }
    return minutes
    }
    
    
    fileprivate func calculateInterval(_ hour: String, split: String) -> Int{
        let hourInMinutes = converHourToMinutes(hour)
        let minutes = convertMinuteStringToMinuteInt(split)
        guard hourInMinutes != 0, minutes != 0 else {
            return 0
        }
        
        let interval = hourInMinutes / minutes
        return interval
    }
    fileprivate func updateIntervalCount(_ text: String){
        lblIntervalCount.text = text
    }
    fileprivate func updateIntervalInfo(){
        let interval = calculateInterval(selectedHour, split: selectedMinute)
        if interval != 0 {
            updateIntervalCount("Number of Interval: \(interval)")
        }
    }
    fileprivate func setupFloatingPanelContent() {
        fpController = FloatingPanelController()
        fpController.delegate = self
        fpController.set(contentViewController: contentVC)
        fpController.track(scrollView: contentVC.tableView)
        fpController.isRemovalInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingPanelContent()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
    func showOptions() {
        self.present(fpController, animated: true) {
            print("Options presented")
        }
    }
    
    fileprivate func dismissFloatingPanel() {
        fpController.dismiss(animated: true) {
            print("Options removed")
        }
    }
    @IBAction func hourSelected(_ sender: Any) {
        contentVC.listofOption = hours
        contentVC.optionSelectionCompletionHandler = { [unowned self] (selectedOption) in
            self.selectedHour = selectedOption
            self.fpController.dismiss(animated: true, completion: {
                print("Hours list dismissed")
            })
            self.updateIntervalInfo()
        }
        showOptions()
    }
    
    @IBAction func splitSelected(_ sender: Any) {
        contentVC.listofOption = splits
        contentVC.optionSelectionCompletionHandler = { [unowned self] (selectedOption) in
            self.selectedMinute = selectedOption
            self.fpController.dismiss(animated: true, completion: {
                print("Split Selection Dismissed")
            })
            self.updateIntervalInfo()
        }
        showOptions()
    }
}
