//
//  EmployeeEntryViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 6/11/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit
import CurrencyTextField
//import ChameleonFramework
import SkyFloatingLabelTextField

class EmployeeEntryViewController: UITableViewController {
  
  var serverArray = Array<String>()
  var barbackArray = Array<String>()
  var serverHours = Array<String>()
  var barbackHours = Array<String>()
  var serverPayoutText = Array<String>()
  var barbackPayoutText = Array<String>()
  var shareText = Array<String>()
  
  var barbackSplitPercentage: Decimal = 0.00
  var percentageIsCash: Decimal = 0.00
  
  var totalTipsForLabel = ""
  var totalTips: Decimal = 0.00
  
  var serverTipsPerHour: String = ""
  var barbackTipsPerHour: String = ""
  
  @IBOutlet weak var employeeNameTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var hoursTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var totalTipsLabel: UILabel!
  @IBOutlet weak var hoursEntryStackView: UIStackView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg"))
    
    totalTipsLabel.text = totalTipsForLabel
    
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
        
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSAttributedString.Key.foregroundColor: UIColor.white,
       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .light)]
    
    tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg"))

    employeeNameTextField.lineColor = UIColor.white
    hoursTextField.lineColor = UIColor.white
    employeeNameTextField.placeholderColor = UIColor.white
    hoursTextField.placeholderColor = UIColor.white
    
    self.tableView.tableFooterView = UIView()
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
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){

    let header = view as! UITableViewHeaderFooterView
    view.tintColor =  UIColor.clear
    header.textLabel?.textColor = UIColor.white
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let barbackTips = totalTips * (barbackSplitPercentage / 100)
    let serverTips = totalTips - barbackTips
    let totalTipsText = String(format: "%.2f", Double(truncating: totalTips as NSNumber))
    let barbackText = String(format: "%.2f", Double(truncating: barbackTips as NSNumber))
    let serverText = String(format: "%.2f", Double(truncating: serverTips as NSNumber))
    
    if barbackSplitPercentage == 0.00 {
      if section == 0 {
        return "Servers  $\(totalTipsText)   TPH: $\(serverTipsPerHour)"
      } else {
        return "Support  $0.00   TPH: $\(barbackTipsPerHour)"
      }
    } else {
      if section == 0 {
        return "Servers  $\(serverText)   TPH: $\(serverTipsPerHour)"
      } else {
        return "Support  $\(barbackText)    TPH: $\(barbackTipsPerHour)"
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    tableView.separatorStyle = .singleLine
    
    let cellColor = UIColor.clear //init(hexString: "d9d3d2")!  //GradientColor(UIGradientStyle.leftToRight, frame: cell.frame, colors: [UIColor(hexString: "4fd9bb")!, UIColor(hexString: "87e5d1")!])
    
    if indexPath.section == 0 {
      let nameAndHours = "\(serverArray[indexPath.row]) worked \(serverHours[indexPath.row]) hours. "
      let payoutText = serverPayoutText[indexPath.row]
      cell.textLabel?.text = "\(serverArray[indexPath.row]): \(serverHours[indexPath.row]) hours"
      cell.detailTextLabel?.text = payoutText
      
      shareText.append("(Bartender) \(nameAndHours) \(payoutText)\n")
      
      cell.backgroundColor = cellColor
      cell.detailTextLabel?.backgroundColor = UIColor.clear
      
    } else {
      
      let nameAndHours = "\(barbackArray[indexPath.row]) worked \(barbackHours[indexPath.row]) hours. "
      cell.textLabel?.text  = "\(barbackArray[indexPath.row]): \(barbackHours[indexPath.row]) hours"
      let payoutText = barbackPayoutText[indexPath.row]
      cell.detailTextLabel?.text = payoutText
      
      shareText.append("(Barback) \(nameAndHours) \(payoutText)\n")

      cell.backgroundColor = cellColor
      cell.detailTextLabel?.backgroundColor = UIColor.clear
  
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      print("Deleted")
      
      if indexPath.section == 0 {
      self.serverArray.remove(at: indexPath.row)
      self.serverHours.remove(at: indexPath.row)
        
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      } else {
        self.barbackArray.remove(at: indexPath.row)
        self.barbackHours.remove(at: indexPath.row)
      }
    }
    calculateTips()
  }
  
  @IBAction func addServerButton(_ sender: UIButton) {
    
    // Add name and hours worked to array
    if employeeNameTextField.text == "" || hoursTextField.text == "" {
      print("Nothing was entered")
      
      let alert = UIAlertController(title: "Error", message: "Invalid input for Employee name or Hours.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
      
      self.present(alert, animated: true)
      
    } else {
      
      guard let text = hoursTextField.text, let _ = Double(text)  else {
        
        let alert = UIAlertController(title: "Error", message: "Invalid input for Hours.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        calculateTips()
        
        print("hoursTextField is not a double")
        return
      }
      serverArray.insert(employeeNameTextField.text!, at: 0)
      serverHours.insert(hoursTextField.text!, at: 0)
    }
    calculateTips()
  }
  
  @IBAction func addBarbackButton(_ sender: UIButton) {
    
    // Add name and hours worked to array
    if employeeNameTextField.text == "" || hoursTextField.text == "" {
      print("Nothing was entered")
      
      let alert = UIAlertController(title: "Error", message: "Invalid input for Employee name or Hours.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
      
      self.present(alert, animated: true)
      
    } else {
      guard let text = hoursTextField.text, let _ = Double(text)  else {
        
        let alert = UIAlertController(title: "Error", message: "Invalid input for Hours.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        calculateTips()
        
        print("hoursTextField is not a double")
        return
      }
      barbackArray.insert(employeeNameTextField.text!, at: 0)
      barbackHours.insert(hoursTextField.text!, at: 0)
    }
    calculateTips()
  }
  
  func calculateTips() {
    
    var totalServerHours: Decimal = 0.00
    var totalBarbackHours: Decimal = 0.00
    var barbackTips: Decimal = 0.00
    var serverTips: Decimal = 0.00
    serverPayoutText = []
    barbackPayoutText = []
    shareText = []
    
    if barbackArray.count == 0 {
      serverTips = totalTips
    } else {
      barbackTips = totalTips * (barbackSplitPercentage / 100)
      serverTips = totalTips - barbackTips
    }
    
    // iterate through hours worked to get total hours
    for hours in serverHours {
      totalServerHours = totalServerHours + Decimal(Double(hours)!)
    }
    for hours in barbackHours {
      totalBarbackHours = totalBarbackHours + Decimal(Double(hours)!)
    }
    
    // divide total tips by hours worked to get $$ per hour
    let serverTipsHourly: Decimal = serverTips / totalServerHours
    let barbackTipsHourly: Decimal = barbackTips / totalBarbackHours
    
    // iterate through array of hours worked and multiply by tips per hour
    for hours in serverHours {
      let serverPayout = Decimal(Double(hours)!) * serverTipsHourly
      let cashPortion = serverPayout * percentageIsCash
      let creditPortion = serverPayout - cashPortion
      
      // save into new array as string that will display in detailTextLabel
      let serverPayoutRounded: String = String(format: "%.2f", Double(truncating: serverPayout as NSNumber))
      let cashPortionRounded = String(format: "%.2f", Double(truncating: cashPortion as NSNumber))
      let creditPortionRounded = String(format: "%.2f", Double(truncating: creditPortion as NSNumber))
      
      serverPayoutText.append("$\(cashPortionRounded) + $\(creditPortionRounded) = $\(serverPayoutRounded)")
      
      let serverTipsPerHourRounded = String(format: "%.2f", Double(truncating: serverTipsHourly as NSNumber))
      serverTipsPerHour = serverTipsPerHourRounded
    }
    
    for hours in barbackHours {
      let barbackPayout = Decimal(Double(hours)!) * barbackTipsHourly
      let cashPortion = barbackPayout * percentageIsCash
      let creditPortion = barbackPayout - cashPortion
      
      // save into new array as string that will display in detailTextLabel
      let barbackPayoutRounded = String(format: "%.2f", Double(truncating: barbackPayout as NSNumber))
      let cashPortionRounded = String(format: "%.2f", Double(truncating: cashPortion as NSNumber))
      let creditPortionRounded = String(format: "%.2f", Double(truncating: creditPortion as NSNumber))
      
      barbackPayoutText.append("$\(cashPortionRounded) + $\(creditPortionRounded) = $\(barbackPayoutRounded)")
      
      let barbackTipsPerHourRounded = String(format: "%.2f", Double(truncating: barbackTipsHourly as NSNumber))
      barbackTipsPerHour = barbackTipsPerHourRounded
    }
    
    employeeNameTextField.text = ""
    hoursTextField.text = ""
    tableView.reloadData()
  }
  
  // share text
  @IBAction func shareTextButton(_ sender: UIBarButtonItem) {
    
    // text to share
    let text = shareText.joined(separator: "\n")
    print(text)
    
    // set up activity view controller
    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    // present the view controller
    self.present(activityViewController, animated: true, completion: nil)
    
  }
  
  
  
}


public extension UIView {
  public func pin(to view: UIView) {
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: view.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topAnchor.constraint(equalTo: view.topAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }
}
