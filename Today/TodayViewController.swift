//
//  TodayViewController.swift
//  Today
//
//  Created by Upendra Tripathi on 3/6/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
//import AudioToolbox

import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    private var heartbeatTimer: RepeatingTimer?
    private var startDate = Date()
    private var activityDate = Calendar.current.date(byAdding: .second, value: 602, to: Date())

    @IBOutlet weak var lblActivityTitle: UILabel!
    
    @IBOutlet weak var lblActivityCounter: UILabel!
    var currentActivityTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        let userDefault = UserDefaults(suiteName: "group.DeepWork")
        let activity = userDefault?.value(forKey: "CurrentActivity")
        if let activity = activity {
            currentActivityTitle = activity as? String ?? "-"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblActivityTitle.text = currentActivityTitle
        startTimer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    private func startTimer() {
        // Should not be starting a timer that's already started.
        self.updateTimerLabel()
        precondition(heartbeatTimer == nil)
        heartbeatTimer = RepeatingTimer(timeInterval: 1.0)
        heartbeatTimer?.eventHandler = {
            self.updateTimerLabel()
        }
        heartbeatTimer?.resume()
    }
    
    private func updateTimerLabel(){
        DispatchQueue.main.async { [unowned self] in
            let elapsedTime = self.elapsedTime()
            let (hour, minute, second) = elapsedTime.HHMMSS()
            let timeString = String.init(format: "%02d : %02d : %02d", hour, minute, second)
//            if hour == 0 && minute == 10 && second == 0{
//                AudioServicesPlaySystemSound(1023) // Different audio references http://iphonedevwiki.net/index.php/AudioServices
//            }
            self.lblActivityCounter.text = timeString
        }
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    private func stopTimer() {
        // Should not be stopping a timer that's not started
        precondition(heartbeatTimer != nil)
        
        //        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    private func elapsedTime() -> TimeInterval {
        if let activityDate = activityDate {
            let time = abs(Date().timeIntervalSince(activityDate))
            return time
        }
        return TimeInterval.init()
    }
}
