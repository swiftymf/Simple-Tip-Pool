//
//  TipEntryViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 6/11/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit
import CoreData
import CurrencyTextField
import SkyFloatingLabelTextField

class TipEntryViewController: UIViewController {
  
  var cashTips = Decimal()
  var creditTips = Decimal()
  var barbackSplit = Decimal()
  
  var totalTips = Decimal()
  var percentageOfTipsAreCash = Decimal()
  var tips = String()
  var tiersArray: [TiersClass] = []
  var tiers: [NSManagedObject] = []
  
  let tierTVC = TierTableViewController()
  

  
  @IBOutlet weak var cashTipsTextField: UITextField!
  @IBOutlet weak var creditTipsTextField: UITextField!
  @IBOutlet weak var barbackSplitTextField: UITextField!
  
  @IBAction func infoButtonTapped(_ sender: UIButton) {
    let alert = UIAlertController(title: "How to use:", message: "1. Enter Cash and Credit card tips\n\n2. Enter % for barbacks\n(ignore if using points system)\n\n3. Choose Split Hourly or Split by Points\n\n4. Enter employee name and hours worked\n\n5. Choose server or barback for hourly split or select position for splitting by points\n\nAs you add employees, tips will be calculated automatically\n\n If splitting by points, if you will first need to create the positions and assign point values by tapping the Positions button in the top right of this screen.\n\nYou only need to do this once and the app will remember your entries. Swipe to delete if needed.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nil))
    
    self.present(alert, animated: true)
  }
  
  
  
  // Create share button (text, email, etc.)
  // Also need to format table to readable text
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    
    // Nav bar background color (change view background in storyboard)
    navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "93827f")    //UIColor.flatForestGreen
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tiersArray.removeAll()
    //1
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    //2
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tiers")
    //3
    do {
      tiers = try managedContext.fetch(fetchRequest)
      print(tiers)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    print("Cash Tips skyScannerTextfield: \(cashTipsTextField.text!)")
    
    if segue.identifier == "HourlySegue"  {
      if let employeeVC = segue.destination as? EmployeeEntryViewController {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal  //.currency
        
        print("Cash number skyScannerTextfield: \(formatter.number(from: cashTipsTextField.text!))")
        
        if let number1 = formatter.number(from: cashTipsTextField.text!) {
          cashTips = number1.decimalValue
          print("cash tips are \(cashTips)")
        }
        if let number1 = formatter.number(from: creditTipsTextField.text!) {
          creditTips = number1.decimalValue
          print("credit tips are \(creditTips)")
        }
        
        if cashTips == 0 && creditTips == 0 {
          let alert = UIAlertController(title: "No tips?", message: "You didn't make any tips today? Double check those amounts because you definitely deserved some tips for all your hard work.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: nil))
          
          self.present(alert, animated: true)
        }
        
        barbackSplit = Decimal(Double(barbackSplitTextField.text!) ?? 0.00)
        
        totalTips = cashTips + creditTips
        print("Total tips: \(totalTips)")
        
        percentageOfTipsAreCash = cashTips / totalTips
        tips = String(format: "%.2f", Double(truncating: totalTips as NSNumber))
        print("Tips are \(tips)")
        
        employeeVC.barbackSplitPercentage = barbackSplit
        employeeVC.percentageIsCash = percentageOfTipsAreCash
        employeeVC.totalTips = totalTips
        employeeVC.totalTipsForLabel = "Total tips $\(tips)"
      }
      
    } else if segue.identifier == "QuickSplitSegue" {
      
      if let quickSplitVC = segue.destination as? QuickSplitViewController {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let number1 = formatter.number(from: cashTipsTextField.text!) {
          cashTips = number1.decimalValue
          print("cash tips are \(cashTips)")
        }
        if let number1 = formatter.number(from: creditTipsTextField.text!) {
          creditTips = number1.decimalValue
          print("credit tips are \(creditTips)")
        }
        
        if cashTips == 0 && creditTips == 0 {
          let alert = UIAlertController(title: "No tips?", message: "You didn't make any tips today? Double check those amounts because you definitely deserved some tips for all your hard work.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: nil))
          
          self.present(alert, animated: true)
        }
        
        barbackSplit = Decimal(Double(barbackSplitTextField.text!) ?? 0.00)
        percentageOfTipsAreCash = cashTips / totalTips
        totalTips = cashTips + creditTips
        tips = String(format: "%.2f", Double(truncating: totalTips as NSNumber))
        quickSplitVC.barbackSplitPercentage = barbackSplit
        quickSplitVC.totalTipsForLabel = "Total tips $\(tips)"
        quickSplitVC.totalTips = totalTips
      }
        
      } else if segue.identifier == "PointsSegue" {
        if tiers.isEmpty {
          let alert = UIAlertController(title: "No positions found", message: "It looks like you haven't added any positions yet. Tap the Positions button in the top right corner and add positions and their point values that are included in your tip pool.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
          
          self.present(alert, animated: true)
        } else {
          if let tierVC = segue.destination as? TierEmployeeEntryViewController {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            
            if let number1 = formatter.number(from: cashTipsTextField.text!) {
              cashTips = number1.decimalValue
              print("cash tips are \(cashTips)")
            }
            if let number1 = formatter.number(from: creditTipsTextField.text!) {
              creditTips = number1.decimalValue
              print("credit tips are \(creditTips)")
            }
            
            if cashTips == 0 && creditTips == 0 {
              let alert = UIAlertController(title: "No tips?", message: "You didn't make any tips today? Double check those amounts because you definitely deserved some tips for all your hard work.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: nil))
              
              self.present(alert, animated: true)
            }
            
            totalTips = cashTips + creditTips
            
            percentageOfTipsAreCash = cashTips / totalTips
            tips = String(format: "%.2f", Double(truncating: totalTips as NSNumber))
            print("Tips are \(tips)")
            
            tierVC.percentageIsCash = percentageOfTipsAreCash
            tierVC.totalTips = totalTips
            tierVC.totalTipsForLabel = "Total tips $\(tips)"
            
          }
        }
      }
    }
  
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
