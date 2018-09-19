//
//  TipEntryViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 6/11/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit
import CoreData

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
  
//  @IBAction func infoButtonTapped(_ sender: UIButton) {
//    let alert = UIAlertController(title: "How to use:", message: "1. Enter Cash and Credit card tips\n\n2. Enter % for barbacks\n(or other support staff)\n\n3. Tap Next\n\n4. Enter employee name and hours worked\n\n5. Choose server or barback\n\nAs you add employees, tips will be calculated automatically.", preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nil))
//    
//    self.present(alert, animated: true)
//  }
  

  
  // Create share button (text, email, etc.)
  // Also need to format table to readable text
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Nav bar background color (change view background in storyboard)
    navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "93827f")    //UIColor.flatForestGreen
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
  
    
//    // Create the info button
//    let infoButton = UIButton(type: .infoLight)
//    
//    // You will need to configure the target action for the button itself, not the bar button item
//    infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
//    
//    // Create a bar button item using the info button as its custom view
//    let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
//    
//    // Use it as required
//    navigationItem.rightBarButtonItem = infoBarButtonItem
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
    if segue.identifier == "NextSegue"  {
      if let employeeVC = segue.destination as? EmployeeEntryViewController {
        
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
    }
  }
  
  
}

