//
//  TodayViewController.swift
//  Today
//
//  Created by Upendra Tripathi on 3/6/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
//import AudioToolbox
import RealmSwift

import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    private var heartbeatTimer: RepeatingTimer?
    private var startDate = Date()
    private var activityDate: Date?

    @IBOutlet weak var lblActivityTitle: UILabel!
    @IBOutlet weak var lblActivityCounter: UILabel!

    lazy var activities: Results<UPTActivity> = {
        Realm.realmInstance.objects(UPTActivity.self)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.realmInstance.configuration.description)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let activity = getCurrentActivity()
        if let currentActivity = activity {
            lblActivityTitle.text = currentActivity.name
            activityDate = currentActivity.endDateTime
            startTimer()
        }else{
            lblActivityTitle.text = "No activity scheduled currently!"
            lblActivityCounter.text = "- : - : -"
        }
    }
    
    private func isCurrentActivity(_ activity: UPTActivity) -> Bool{
        let now = Date()
        if activity.startDateTime <= now && activity.endDateTime >= now {
            return true
        }
        return false
    }
    
    private func getCurrentActivity() -> UPTActivity?{
        for activity in activities{
            if isCurrentActivity(activity){
                print(activity.name)
                return activity
            }
        }
        return nil
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
