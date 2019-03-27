//
//  AddBookmarkViewController.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/27/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit
import FloatingPanel
import RealmSwift

class AddBookmarkViewController: UIViewController {
    var dateTimeViewController: DateTimeViewController!
    var fpController: FloatingPanelController!

    @IBOutlet weak var btnBookmarkDate: UIButton!

    @IBOutlet weak var txtBookmarkTittle: UITextField!
    var selectedDate: Date? {
        didSet{
            self.btnBookmarkDate.setTitle(selectedDate?.toString(), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingPanelContent()
        setupDateController()
    }
    @IBAction func selectBookmarkDate(_ sender: Any) {
        fpController.set(contentViewController: dateTimeViewController)
        showOptions()
    }
    
    private func removeOptions(){
        self.dismiss(animated: true) {
            print("Option Dismissed")
        }
    }
    private func showOptions() {
        self.removeOptions()
        self.present(fpController, animated: true) {
            print("Options Presented")
        }
    }
    @IBAction func addBookmark(_ sender: Any) {
        let title = txtBookmarkTittle.text
        guard let bookmarkTitle = title, let bookmarkDate = selectedDate else{
            print("Enter Bookmark Title and Select Bookmark Date")
            return
        }
        try! Realm.realmInstance.write() {
            let newBookmark = UPTBookmark(title: bookmarkTitle, date: bookmarkDate)
            Realm.realmInstance.add(newBookmark)
        }
    }
    @IBAction func bookmarkTitleEntryDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtBookmarkTittle.resignFirstResponder()
    }
    
    fileprivate func setupFloatingPanelContent() {
        fpController = FloatingPanelController()
        fpController.isRemovalInteractionEnabled = true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
