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
  var arrayOfPositions: [String] = []
  var arrayOfEmployees: [[Employee]] = [[], [], [], []]
  var titleForHeader: String = ""
  
  var percentageIsCash: Decimal = 0.00
  var totalTipsForLabel = ""
  var totalTips: Decimal = 0.00
  
  @IBOutlet weak var tierButtonLabel: UIButton!
  @IBOutlet weak var employeeNameTextField: UITextField!
  @IBOutlet weak var hoursTextField: UITextField!
  @IBOutlet weak var totalTipsLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tierButtonLabel.setTitle("Select Position", for: .normal)
    
    totalTipsLabel.text = totalTipsForLabel

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
        
    for tier in tiers {
      let position = tier.value(forKey: "position") as! String
      let weight = tier.value(forKey: "weight") as! String

      tiersArray.append(TiersClass(position: position, weight: weight))
      
      print("tiersArray: \(tiersArray)")
    }
    
    for tier in tiersArray {
      let position = tier.position
    //  let weight = tier.weight
      
      tierStrings[0].append("\(position)")
      print("tierStrings: \(tierStrings)")
    }
    createArraysFromTiers()
  }
  
  func createArraysFromTiers() {
    arrayOfPositions.removeAll()
    for i in tiersArray {
      // make an array positions as Strings that will be the section header titles
      // when entering employees/hours, match the position name to the section title for sorting into sections
      arrayOfPositions.append(i.position)
      print("\(i.position) added to arrayOfPositions")
      // append each tier as an array into the array of arrays with position name as the array name
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {

    return tiersArray.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    // Amount of arrays will equal amount of positions/tiers
    // Figure out how to take unknown amount of arrays and translate to this
    // Ex: bartender.count, barback.count, someOtherPosition.count
    // if section header = position add some some mystery array
    // for i in arrayOfPostiions {
    // if i == Employee.position {
    // arrayOfEmployees.insert(Employee, at: i)
    // }
    // }
    let numberOfSections = tiersArray.count
    var numberOfRows = 0
    for i in 0...numberOfSections {
      if section == i {
        numberOfRows = arrayOfEmployees[i].count
      }

    }
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

    for i in 0...section {
      titleForHeader =  "\(tiersArray[i].position): \(tiersArray[i].weight)"   //arrayOfPositions[i]
    }
    
    return titleForHeader
  }
  
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let numberOfSections = tiersArray.count
    
    for i in 1...numberOfSections {
      print("i: \(i)")
      if indexPath.section == i - 1 {
        cell.textLabel?.text = "\(arrayOfEmployees[indexPath.section][indexPath.row].name): \(arrayOfEmployees[indexPath.section][indexPath.row].hours) hours"
        
        // "\(arrayOfEmployees[indexPath.section][indexPath.row].name): hours worked"
        
        // cell.detailTextLabel?.text = cash tips + credit card tips = total tips
        
        break
      } else {
        cell.textLabel?.text = "Something went wrong"
      }
    }
    return cell
  }
  
  @IBAction func addEmployeeButtonPressed(_ sender: UIButton) {
    
    if employeeNameTextField.text == "" || hoursTextField.text == "" {
      let alert = UIAlertController(title: "Error", message: "Make sure that Employee Name and Hours are NOT blank", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: nil))
      self.present(alert, animated: true)
    } else {
      addNewEmployee()

    }
    employeeNameTextField.text = ""
    hoursTextField.text = ""
  }
  
  
  func sortEmployeesByPosition() {
    
    // Run this in cellForRow?
    // interate through arrayOfPositions/arrayOfEmployees to sort Employees into positions, calculate, then display in tableView
    
  }
  
  func addNewEmployee() {
    let newEmployee = Employee()
    newEmployee.name = employeeNameTextField.text ?? "No name entered"
    newEmployee.hours = hoursTextField.text ?? "no hours entered"

    // Adding the newEmployee everytime it runs through. need to stop that.
    // selected position needs to match the string in arrayOfPositions, get that index, add to arrayOfEmployees at that index
    
    
    for (index, element) in arrayOfPositions.enumerated() {

      newEmployee.weight = tiersArray[index].weight  // this is assigning the wrong value
      newEmployee.position = tiersArray[index].position  // this is assigning the wrong value

      if element == tierButtonLabel.titleLabel?.text {
        arrayOfEmployees[index].append(newEmployee)
        print("Element: \(element)")
        print("newEmployee \(newEmployee.position, newEmployee.weight, newEmployee.hours, newEmployee.name)") // weight, position wrong
        print("arrayOfEmployees \(arrayOfEmployees)")
        print("index: \(index)")
      }
      
      print("index: \(index), element: \(element)")
    }
    tableView.reloadData()
  }
  
}
