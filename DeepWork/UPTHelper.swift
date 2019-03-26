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
