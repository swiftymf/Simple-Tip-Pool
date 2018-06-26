//
//  EmployeeEntryViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 6/11/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit

class EmployeeEntryViewController: UITableViewController {

    var serverArray = Array<String>()
    var barbackArray = Array<String>()
    var serverHours = Array<String>()
    var barbackHours = Array<String>()
    var serverPayoutText = Array<String>()
    var barbackPayoutText = Array<String>()
    
    var barbackSplitPercentage = 0.00
    var percentageIsCash = 0.00
    
    var totalTipsForLabel = ""
    var totalTips = 0.00
    
    @IBOutlet weak var employeeNameTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var totalTipsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalTipsLabel.text = totalTipsForLabel
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
        return serverArray.count
        } else {
            return barbackArray.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Servers              (Cash + Credit)"
        } else {
            return "Barbacks           (Cash + Credit)"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text  = "\(serverArray[indexPath.row]): \(serverHours[indexPath.row]) hours"
            cell.detailTextLabel?.text = serverPayoutText[indexPath.row]
        } else {
            cell.textLabel?.text  = "\(barbackArray[indexPath.row]): \(barbackHours[indexPath.row]) hours"
            cell.detailTextLabel?.text = barbackPayoutText[indexPath.row]
        }
        return cell
    }
    
    
    @IBAction func addServerButton(_ sender: UIButton) {
    
        // Add name and hours worked to array
        if employeeNameTextField.text == "" || hoursTextField.text == "" {
            print("Nothing was entered")
        } else {
        serverArray.insert(employeeNameTextField.text!, at: 0)
        serverHours.insert(hoursTextField.text!, at: 0)
        }
        calculateTips()
    }
    
    @IBAction func addBarbackButton(_ sender: UIButton) {
        
        // Add name and hours worked to array
        if employeeNameTextField.text == "" || hoursTextField.text == "" {
            print("Nothing was entered")
        } else {
            guard let text = hoursTextField.text, let _ = Double(text)  else {
                
                let alert = UIAlertController(title: "Error", message: "Invalid input for Hours.", preferredStyle: .alert)
                
        //        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
                calculateTips()
                
                print("hoursTextField is not a double")
                return
            }
            barbackArray.insert(employeeNameTextField.text!, at: 0)
            //let hours = Double(hoursTextField.text!)
            barbackHours.insert(hoursTextField.text!, at: 0)
        }
        calculateTips()
    }
    
    func calculateTips() {
        
        var totalServerHours = 0.00
        var totalBarbackHours = 0.00
        var barbackTips = 0.00
        var serverTips = 0.00
        //var text = "\(hours) hours, $\(serverPayout)"
        
        // This should only happen if there are barbacks, otherwise no split
        // calculate barback split
        
//        barbackTips = totalTips * (barbackSplitPercentage / 100)
//        serverTips = totalTips - barbackTips
//        print("barback tips \(barbackTips)")
//        print("server tips \(serverTips)")
        
        if barbackArray.count == 0 {
            serverTips = totalTips
            print("Server tips are \(serverTips)")
        } else {
            barbackTips = totalTips * (barbackSplitPercentage / 100)
            serverTips = totalTips - barbackTips
            print("barback tips \(barbackTips)")
            print("server tips \(serverTips)")
        }
        
        // iterate through hours worked to get total hours
        for hours in serverHours {
            totalServerHours = totalServerHours + Double(hours)!
            print("Total server hours \(totalServerHours)")
        }
        for hours in barbackHours {
            totalBarbackHours = totalBarbackHours + Double(hours)!
            print("Total server hours \(totalBarbackHours)")
        }
        
        // divide total tips by hours worked to get $$ per hour
        let serverTipsHourly = serverTips / totalServerHours
        let barbackTipsHourly = barbackTips / totalBarbackHours
        print("server hourly tips are \(serverTipsHourly)")

        // iterate through array of hours worked and multiply by tips per hour
        for hours in serverHours {
            let serverPayout = Double(hours)! * serverTipsHourly
            print("server payout \(serverPayout)")
            
            let cashPortion = serverPayout * percentageIsCash
            let creditPortion = serverPayout - cashPortion
            
            // save into new array as string that will display in detailTextLabel
            let serverPayoutRounded = String(format: "%.2f", serverPayout)
            let cashPortionRounded = String(format: "%.2f", cashPortion)
            let creditPortionRounded = String(format: "%.2f", creditPortion)
            
            serverPayoutText.insert("\(cashPortionRounded) + \(creditPortionRounded) =  $\(serverPayoutRounded)", at: 0)

        }
        for hours in barbackHours {
            let barbackPayout = Double(hours)! * barbackTipsHourly
            let cashPortion = barbackPayout * percentageIsCash
            let creditPortion = barbackPayout - cashPortion
            
            // save into new array as string that will display in detailTextLabel
            let barbackPayoutRounded = String(format: "%.2f", barbackPayout)
            let cashPortionRounded = String(format: "%.2f", cashPortion)
            let creditPortionRounded = String(format: "%.2f", creditPortion)
            
            barbackPayoutText.insert("\(cashPortionRounded) + \(creditPortionRounded) = $\(barbackPayoutRounded)", at: 0)
        }

        employeeNameTextField.text = ""
        hoursTextField.text = ""
        tableView.reloadData()
    }

    


}
