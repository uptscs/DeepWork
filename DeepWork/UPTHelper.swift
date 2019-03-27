//
//  UPTHelper.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/23/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
import RealmSwift

extension TimeInterval {
    func HHMMSS() -> (hour: Int, minute: Int, second:Int) {
        let hours = Int(self) / (60*60)
        let minutes = (Int(self) - hours * 60*60) / 60
        let seconds = Int(self) % 60
//        let timeString = String.init(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return (hours, minutes, seconds)
    }
}

class RepeatingTimer {
    let timeInterval: TimeInterval
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating:self.timeInterval)
        t.setEventHandler(handler: {
            [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    var eventHandler: (() -> Void)?
    private enum State {
        case suspended
        case resumed
    }
    private var state: State = .suspended
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here
         https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
}

extension Realm{
    static var realmInstance: Realm {
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.DeepWork")!.appendingPathComponent("db.realm")
        let config = Realm.Configuration(fileURL: fileURL)
        return try! Realm(configuration: config)
    }
}

extension Date{
    func remainingDaysFromToday() -> Int?{
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for:self)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day

    }
    func toString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
    
    func toAMPMOnlyString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }

    func addMinutes(_ minutes: Int) -> Date? {
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }
}

extension String{
    var inMinute: Int {
        get {
            var duration = 0
            switch self {
            case "5 Minutes":
                duration = 5
            case "10 Minutes":
                duration = 10
            case "15 Minutes":
                duration = 15
            case "20 Minutes":
                duration = 20
            case "30 Minutes":
                duration = 30
            case "45 Minutes":
                duration = 45
            case "1 Hour":
                duration = 60
            case "2 Hours":
                duration = 120
            case "3 Hours":
                duration = 180
            case "4 Hours":
                duration = 240
            case "5 Hours":
                duration = 300
            case "8 Hours":
                duration = 480
            case "10 Hours":
                duration = 600
            case "12 Hours":
                duration = 720
            default:
                duration = 0
            }
            return duration
        }
    }
}
