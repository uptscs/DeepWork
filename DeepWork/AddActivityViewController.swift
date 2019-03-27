//
//  AddActivityViewController.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/26/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
import FloatingPanel
import RealmSwift

class AddActivityViewController: UIViewController {

    @IBOutlet weak var btnDuration: UIButton!
    @IBOutlet weak var btnStartTime: UIButton!
    @IBOutlet weak var txtActivityName: UITextField!
    var selectedDate: Date? {
        didSet{
            self.btnStartTime.setTitle(selectedDate?.toString(), for: .normal)
        }
    }
    let contentVC = SelectionOptionViewController()
    var dateTimeViewController: DateTimeViewController!
    
    var fpController: FloatingPanelController!
    let durations = ["5 Minutes","10 Minutes", "15 Minutes", "20 Minutes", "30 Minutes", "45 Minutes", "1 Hour", "2 Hours", "3 Hours", "4 Hours", "5 Hours", "8 Hours", "10 Hours", "12 Hours"]
    
    fileprivate func setupFloatingPanelContent() {
        fpController = FloatingPanelController()
        fpController.isRemovalInteractionEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingPanelContent()
        setupDateController()
    }
    @IBAction func addActivity(_ sender: Any) {
        let name = txtActivityName.text
        let startDate = selectedDate
        let minutes = btnDuration.titleLabel?.text?.inMinute
        let endDate = selectedDate?.addMinutes(minutes!)
        guard minutes != 0, let activityName = name, let activityStartDate = startDate, let activityEndDate = endDate else{
            print("Activity not created, select Activity Name, Start time and Duration")
            return
        }
        try! Realm.realmInstance.write() {
            let newActivity = UPTActivity(name: activityName, startDate: activityStartDate, endDate: activityEndDate)
            Realm.realmInstance.add(newActivity)
        }
        selectedDate = activityEndDate
        txtActivityName.text = ""

    }
    
    @IBAction func textFieldDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    private func setupDateController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        dateTimeViewController =  storyboard.instantiateViewController(withIdentifier: "DateTimeViewController") as! DateTimeViewController
        dateTimeViewController.dateSelectionCompletionHandler = { [unowned self] (selectedDate: Date) in
            self.selectedDate = selectedDate
            self.fpController.dismiss(animated: true, completion: {
                print("Date Selection Dismissed")
            })
        }
    }

    @IBAction func startDateTimeTapped(_ sender: Any) {
        fpController.set(contentViewController: dateTimeViewController)
        showOptions()
    }

    private func showOptions() {
        self.removeOptions()
        self.present(fpController, animated: true) {
            print("Options Presented")
        }
    }
    private func removeOptions(){
        self.dismiss(animated: true) {
            print("Option Dismissed")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeOptions()
        txtActivityName.resignFirstResponder()
    }
    
    @IBAction func durationTapped(_ sender: Any) {
        fpController.set(contentViewController: contentVC)
        fpController.track(scrollView: contentVC.tableView)
        contentVC.listofOption = durations
        contentVC.optionSelectionCompletionHandler = { [unowned self] (selectedOption) in
            self.btnDuration.setTitle(selectedOption, for: .normal)
            self.fpController.dismiss(animated: true, completion: {
                print("Split Selection Dismissed")
            })
        }
        showOptions()
    }
}
