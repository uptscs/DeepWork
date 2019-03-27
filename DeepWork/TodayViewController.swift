//
//  TodayViewController.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/6/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
import RealmSwift

class TodayViewController: UITableViewController {

    lazy var activities: Results<UPTActivity> = {
        Realm.realmInstance.objects(UPTActivity.self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        populateDefaultActivities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadActivities()
    }
    
    private func reloadActivities(){
        activities = Realm.realmInstance.objects(UPTActivity.self)
        tableView.reloadData()
        let currentTimeRow = getCurrentActivityIndex()
        if let currentTimeRow = currentTimeRow{
            let currentTimeInexPath = IndexPath(row: currentTimeRow, section: 0)
            tableView.scrollToRow(at: currentTimeInexPath, at: .top, animated: true)
        }
    }
    private func getCurrentActivityIndex() -> Int?{
        let now = Date()
        for activity in activities {
            if activity.startDateTime <= now && activity.endDateTime >= now {
                return activities.index(of: activity)
            }
        }
        return nil
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCellIdentifier")
        let activity = activities[indexPath.row]
        cell?.textLabel?.text = activity.name
        cell?.detailTextLabel?.text = "\(activity.startDateTime.toAMPMOnlyString())) - \(activity.endDateTime.toAMPMOnlyString())"
        return cell ?? UITableViewCell(frame: tableView.frame)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 200.0
        }
        return 80.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = activities[indexPath.row]
        let nextActivityIndex = indexPath.row + 1;
        var nextActivity: UPTActivity?
        if nextActivityIndex < activities.count{
            nextActivity = activities[nextActivityIndex]
        }
        showFullScreenView(forActivity: activity, nextActivity:nextActivity)
    }
    
    private func showFullScreenView(forActivity activity:UPTActivity, nextActivity: UPTActivity?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fullScreenVC =  storyboard.instantiateViewController(withIdentifier: "FullScreenCounterViewController") as! FullScreenCounterViewController
        fullScreenVC.currentActivityName = activity.name
        fullScreenVC.activityEndDateTime = activity.endDateTime
        fullScreenVC.activityStartDateTime = activity.startDateTime
        if let nextActivty = nextActivity {
            fullScreenVC.nextActivityName = nextActivty.name
        }
        present(fullScreenVC, animated: false, completion: nil)
    }
    
    private func populateDefaultActivities() {
        if activities.count == 0 {
            try! Realm.realmInstance.write() {
                let defaultActivities =
                    getDefaultActivities()
                
                for activity in defaultActivities {
                    Realm.realmInstance.add(activity)
                }
            }
            activities = Realm.realmInstance.objects(UPTActivity.self)
        }
    }
}

extension TodayViewController{
    fileprivate func getDefaultActivities() -> Array<UPTActivity>{
        //For Start Date
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let dateAtMidnight = calendar.startOfDay(for: Date())
        
        var activityDate = Calendar.current.date(byAdding: .hour, value: 5, to: dateAtMidnight) ?? Date()
        var activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        
        let activity1 = UPTActivity(name: "Fresh", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate)  ?? Date()
        let activity2 = UPTActivity(name: "Meditation", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity3 = UPTActivity(name: "Workout First Part", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity4 = UPTActivity(name: "Workout Second Part", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity5 = UPTActivity(name: "Post Workout Rest", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity6 = UPTActivity(name: "Drop to Bus Stop", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity7 = UPTActivity(name: "Shower", startDate: activityDate, endDate: activityDateWith30Min)

        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity8 = UPTActivity(name: "Daily Ritual", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity9 = UPTActivity(name: "Lunch", startDate: activityDate, endDate: activityDateWith30Min)

        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity10 = UPTActivity(name: "Office Commute", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity11 = UPTActivity(name: "Office - 1", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity12 = UPTActivity(name: "Office - 2", startDate: activityDate, endDate: activityDateWith30Min)

        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity13 = UPTActivity(name: "Office - 3", startDate: activityDate, endDate: activityDateWith30Min)

        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity14 = UPTActivity(name: "Office - 4", startDate: activityDate, endDate: activityDateWith30Min)


        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity15 = UPTActivity(name: "Office - 5", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity16 = UPTActivity(name: "Office - 6", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity17 = UPTActivity(name: "Office - Recreation 1", startDate: activityDate, endDate: activityDateWith30Min)

        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity18 = UPTActivity(name: "Office - Recreation 2", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity19 = UPTActivity(name: "Office - 7", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity20 = UPTActivity(name: "Office - 8", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity21 = UPTActivity(name: "Office - Recreation 9", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity22 = UPTActivity(name: "Office - Recreation 10", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity23 = UPTActivity(name: "Home - Commute", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity24 = UPTActivity(name: "Rest", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity25 = UPTActivity(name: "Deep Work Creation 1", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity26 = UPTActivity(name: "Deep Work Creation 2", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity27 = UPTActivity(name: "Deep Work Creation 3", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity28 = UPTActivity(name: "Deep Work Creation 4", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity29 = UPTActivity(name: "Deep Work Creation 5", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity30 = UPTActivity(name: "Deep Work Creation 6", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity31 = UPTActivity(name: "Bus Stop Pickup", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity32 = UPTActivity(name: "Dinner", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .minute, value: 30, to: activityDate) ?? Date()
        let activity33 = UPTActivity(name: "Family Time", startDate: activityDate, endDate: activityDateWith30Min)
        
        activityDate = activityDateWith30Min
        activityDateWith30Min = Calendar.current.date(byAdding: .hour, value: 8, to: activityDate) ?? Date()
        let activity34 = UPTActivity(name: "Sleep", startDate: activityDate, endDate: activityDateWith30Min)
        return [activity1,activity2,activity3,activity4,activity5,activity6,activity7,activity8,activity9,activity10,activity11,activity12,activity13,activity14,activity15,activity16,activity17,activity18,activity19,activity20,activity21,activity22,activity23,activity24,activity25,activity26,activity27,activity28,activity29,activity30,activity31,activity32,activity33,activity34]
    }
}
