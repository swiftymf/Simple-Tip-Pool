//
//  TierEmployeeEntryViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 9/18/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit
import CoreData
import McPicker

class TierEmployeeEntryViewController: UITableViewController {
  
  var tiers: [NSManagedObject] = []
  var tierStrings: [[String]] = [[]]
  var employees: [Employee] = []
  var tiersArray: [TiersClass] = []
  let TierTVC = TierTableViewController()
  
  @IBOutlet weak var tierButtonLabel: UIButton!
  @IBOutlet weak var employeeNameTextField: UITextField!
  @IBOutlet weak var hoursTextField: UITextField!
  @IBOutlet weak var totalTipsLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tierButtonLabel.setTitle("Select Position", for: .normal)

  }
  
  @IBAction func popOverPicker(_ sender: UIButton) {
    
    
    McPicker.showAsPopover(data: tierStrings, fromViewController: self, sourceView: sender, doneHandler: { [weak self] (selections: [Int : String]) -> Void in
      if let name = selections[0] {
        self?.tierButtonLabel.setTitle(name, for: .normal)
      }
      }, cancelHandler: { () -> Void in
        print("Canceled Popover")
    }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
      let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
      self.tierButtonLabel.setTitle(selections[componentThatChanged], for: .normal)
      
      print("Component \(componentThatChanged) changed value to \(newSelection)")
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
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
    
    // This works ok, need to get the other one to work using the array instead of core data
//    for tier in tiers {
//      let position = tier.value(forKey: "position")
//      let weight = tier.value(forKey: "weight")
//
//      tierStrings[0].append("\(position): \(weight))")
//      print("tierStrings: \(tierStrings)")
//    }
    
    // This isn't populating the popoverPicker right now
    tiersArray = TierTVC.tiersArray
    for tier in  tiersArray {
      let position = tier.position
      let weight = tier.weight
      
      tierStrings[0].append("\(position): \(weight))")
      print("tierStrings: \(tierStrings)")
    }
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {

    return tierStrings.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    // Figure out to take unknown amount of arrays and translate to this
    
//    if section == 0 {
//      return serverArray.count   //   tier1Array.count
//    } else {
//      return barbackArray.count  //   tier2Array.count
//    }
    
    
    return 0
  }
  
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
 
//  func addNewEmployee() {
//    let newEmployee = Employee()
//    newEmployee.name = employeeNameTextField.text ?? "No name entered"
//    newEmployee.hours = 10.0  //hoursTextField.text //convert to decimal
//    newEmployee.weight = tiers.value(forKey: "weight")
//    newEmployee.position = tiers.value(forKey: "position")
//
//  }
  
}
