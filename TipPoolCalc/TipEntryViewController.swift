//
//  TipEntryViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 6/11/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField
import SquishButton

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
  

  
  @IBOutlet weak var cashTipsTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var creditTipsTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var barbackSplitTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var splitHourlyButton: SquishButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    cashTipsTextField.lineColor = UIColor.white
    creditTipsTextField.lineColor = UIColor.white
    barbackSplitTextField.lineColor = UIColor.white
    cashTipsTextField.placeholderColor = UIColor.white
    creditTipsTextField.placeholderColor = UIColor.white
    barbackSplitTextField.placeholderColor = UIColor.white
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSAttributedString.Key.foregroundColor: UIColor.white,
       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .light)]
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
    
    if segue.identifier == "HourlySegue"  {
      if let employeeVC = segue.destination as? EmployeeEntryViewController {

        // why is this here and not in the other segues??
//        cashTips = Double(cashTipsTextField.text!) ?? 0.00
//        creditTips = Decimal(Double(creditTipsTextField.text!) ?? 0.00)
        barbackSplit = Decimal(Double(barbackSplitTextField.text!) ?? 0.00)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency //.decimal
        
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
        
        
        if cashTips == 0.00 && creditTips == 0.00 {
          let alert = UIAlertController(title: "No tips?", message: "You didn't make any tips today? Double check those amounts because you definitely deserved some tips for all your hard work.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: nil))
          
          self.present(alert, animated: true)
        }
                
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
        formatter.numberStyle = .currency //.decimal
        
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
            formatter.numberStyle = .currency //.decimal
            
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
