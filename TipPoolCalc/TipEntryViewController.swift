//
//  TipEntryViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 6/11/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit

class TipEntryViewController: UIViewController {

    
    @IBOutlet weak var cashTipsTextField: UITextField!
    
    @IBOutlet weak var creditTipsTextField: UITextField!
    
    @IBOutlet weak var barbackSplitTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextSegue"  {
            if let employeeVC = segue.destination as? EmployeeEntryViewController {
                
                // if cashTips == nil && creditTips == nil {
                //      show alert saying to enter some value
                // }
                
                let barbackSplit: Double = Double(barbackSplitTextField.text!) ?? 0.00
                let cashTips: Double = Double(cashTipsTextField.text!) ?? 0.00
                let creditTips: Double = Double(creditTipsTextField.text!) ?? 0.00
                let totalTips = cashTips + creditTips
                let percentageOfTipsAreCash = cashTips / totalTips
                let tips = String(format: "%.2f", totalTips)
                
                employeeVC.barbackSplitPercentage = barbackSplit
                employeeVC.percentageIsCash = percentageOfTipsAreCash
                employeeVC.totalTips = totalTips
                employeeVC.totalTipsForLabel = "Total tips $\(tips)"
            }
        }
    }
    
    
}

