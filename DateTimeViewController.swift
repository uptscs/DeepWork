//
//  DateTimeViewController.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/26/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import UIKit

class DateTimeViewController: UIViewController {
    var dateSelectionCompletionHandler: ( (Date) -> Void)?

    @IBOutlet weak var dpDateSelector: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: Any) {
        dateSelectionCompletionHandler?(dpDateSelector.date)
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
