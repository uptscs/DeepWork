//
//  FullScreenCounterViewController.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/23/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
import AudioToolbox

class FullScreenCounterViewController: UIViewController {
    private var activityTimer: RepeatingTimer?
//    private var activityDate = Calendar.current.date(byAdding: .second, value: 15, to: Date())
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblActivtyTitle: UILabel!
    @IBOutlet weak var lblNextActivityName: UILabel!
    var currentActivityName = ""
    var activityEndDateTime = Date()
    var activityStartDateTime = Date()
    var nextActivityName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let now = Date()
        if activityEndDateTime > now{
            if activityStartDateTime < now{
                lblActivtyTitle.text = currentActivityName
                lblNextActivityName.text = nextActivityName
                startTimer()
            }else{
                lblActivtyTitle.text = "'\(currentActivityName)' not started yet."
            }
        }else{
            lblActivtyTitle.text = "'\(currentActivityName)' already completed!"
        }
                    lblNextActivityName.text = nextActivityName
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    @IBAction func close(_ sender: Any) {
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    private func startTimer() {
        // Should not be starting a timer that's already started.
        self.updateTimerLabel()
        precondition(activityTimer == nil)
        activityTimer = RepeatingTimer(timeInterval: 1.0)
        activityTimer?.eventHandler = {
            self.updateTimerLabel()
        }
        activityTimer?.resume()
    }
    
    private func updateTimerLabel(){
        let elapsedTime = self.elapsedTime()
        let (hour, minute, second) = elapsedTime.HHMMSS()
        let timeString = String.init(format: "%02d : %02d : %02d", hour, minute, second)
        if hour == 0 && minute == 0 {
            if second == 0 {
                self.stopTimer()
                AudioServicesPlaySystemSound(1114)
                pickNextActivity()
            } else if second < 11{
                AudioServicesPlaySystemSound(1306) // Different audio references http://iphonedevwiki.net/index.php/AudioServices
            }
        }
        DispatchQueue.main.async { [unowned self] in
            self.lblCounter.text = timeString
            
        }
    }
    private func pickNextActivity(){
        // TODO: Pick next activity
    }
    private func stopTimer() {
        // Should not be stopping a timer that's not started
//        precondition(activityTimer != nil)
        //activityTimer?.invalidate()
        activityTimer = nil
    }
    
    private func elapsedTime() -> TimeInterval {
        let time = abs(Date().timeIntervalSince(activityEndDateTime))
        return time
    }
}


