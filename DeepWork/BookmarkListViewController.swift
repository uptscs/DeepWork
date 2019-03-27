//
//  BookmarkListViewController.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/27/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
import RealmSwift

class BookmarkListViewController: UITableViewController {
    lazy var bookmarks: Results<UPTBookmark> = {
        Realm.realmInstance.objects(UPTBookmark.self)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadBookmarks()
    }
    private func reloadBookmarks(){
        bookmarks = Realm.realmInstance.objects(UPTBookmark.self)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCellIdentifier")
        let bookmark = bookmarks[indexPath.row]
        cell?.textLabel?.text = bookmark.title
        if let remainingDays = bookmark.date.remainingDaysFromToday(){
            cell?.detailTextLabel?.text = "\(remainingDays) days remaining"
        }
        return cell ?? UITableViewCell(frame: tableView.frame)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
