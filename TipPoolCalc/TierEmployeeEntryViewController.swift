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
import SkyFloatingLabelTextField

class TierEmployeeEntryViewController: UITableViewController {
  
  var tiers: [NSManagedObject] = []
  var tierStrings: [[String]] = [[]]
  var employees: [Employee] = []
  var tiersArray: [TiersClass] = []
  let TierTVC = TierTableViewController()
  var arrayOfPositions: [String] = []
  var arrayOfEmployees: [[Employee]] = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [],]
  var titleForHeader: String = ""
  var shareText = Array<String>()
  
  var percentageIsCash: Decimal = 0.00
  var totalTipsForLabel = ""
  var totalTips: Decimal = 0.00
  var totalPoints: Decimal = 0.00
  
  
  
  @IBOutlet weak var tierButtonLabel: UIButton!
  @IBOutlet weak var employeeNameTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var hoursTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var totalTipsLabel: UILabel!
  @IBOutlet weak var hoursEntryStackView: UIStackView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    
    tierButtonLabel.setTitle("Select Position", for: .normal)
    
    totalTipsLabel.text = totalTipsForLabel
    
//    // Nav bar background color (change view background in storyboard)
//    navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "93827f")    //UIColor.flatForestGreen
//    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//    
//    pinBackground(backgroundView, to: hoursEntryStackView)
//    
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
  
  private lazy var backgroundView: UIView = {
    let view = UIView()
    
    // Employee entry background color
    //view.backgroundColor = UIColor.init(hexString: "8ae0ad")
    view.backgroundColor = UIColor.clear
    
    return view
  }()
  
  private func pinBackground(_ view: UIView, to stackView: UIStackView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    stackView.insertSubview(view, at: 0)
    view.pin(to: stackView)
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
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
    let header = view as! UITableViewHeaderFooterView
    view.tintColor =  UIColor.clear
    header.textLabel?.textColor = UIColor.white
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
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
    
    tableView.separatorStyle = .singleLine
    let numberOfSections = tiersArray.count
    for i in 1...numberOfSections {
      print("i: \(i)")
      if indexPath.section == i - 1 {
        
        let name = arrayOfEmployees[indexPath.section][indexPath.row].name
        let hours = arrayOfEmployees[indexPath.section][indexPath.row].hours
        
        cell.textLabel?.text = "\(name): \(hours) hours"
        
        let cashPortion = String(format: "%.2f", Double(truncating: (arrayOfEmployees[indexPath.section][indexPath.row].tipsEarned * percentageIsCash) as NSNumber))
        
        let creditPortion = String(format: "%.2f", Double(truncating: (arrayOfEmployees[indexPath.section][indexPath.row].tipsEarned * (1 - percentageIsCash)) as NSNumber))
        
        let stringTips = String(format: "%.2f", Double(truncating: arrayOfEmployees[indexPath.section][indexPath.row].tipsEarned as NSNumber))
        let sharePayoutText = "\(cashPortion) (cash) + \(creditPortion) (credit) = \(stringTips)"
        
        let payoutText = "\(cashPortion) + \(creditPortion) = \(stringTips)"
        
        cell.detailTextLabel?.text = "\(payoutText)"
        
        cell.layer.backgroundColor = UIColor.clear.cgColor //cellColor and remove .layer
        cell.textLabel?.textColor = UIColor.black //ContrastColorOf(cellColor, returnFlat: true)
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
        shareText.append("\(tiersArray[i - 1].position) \(name) worked \(hours) hours. \(sharePayoutText)\n")
        
        break
      } else {
        cell.layer.backgroundColor = UIColor.clear.cgColor //cellColor and remove .layer
        cell.textLabel?.textColor = UIColor.black //ContrastColorOf(cellColor, returnFlat: true)
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.text = "Something went wrong"
      }
      
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      print("Deleted")
      
      self.arrayOfEmployees[indexPath.section].remove(at: indexPath.row) // crashes when delete row
      
      print("tiersArray deleted: \(tiersArray)")
      
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    calculateTips()
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
      
      if element == tierButtonLabel.titleLabel?.text {
        
        newEmployee.weight = tiersArray[index].weight  // this is assigning the wrong value
        newEmployee.position = tiersArray[index].position  // this is assigning the wrong value
        
        arrayOfEmployees[index].append(newEmployee)
        print("Element: \(element)")
        print("newEmployee \(newEmployee.position, newEmployee.weight, newEmployee.hours, newEmployee.name)") // weight, position wrong
        print("arrayOfEmployees \(arrayOfEmployees)")
        print("index: \(index)")
      }
      calculateTips()
      print("index: \(index), element: \(element)")
    }
    tableView.reloadData()
  }
  
  
  func calculateTips() {
    
    var tipsPerPoint: Decimal = 0.00
    totalPoints = 0
    shareText = []
    
    let formatter = NumberFormatter()
    formatter.generatesDecimalNumbers = true
    
    func decimal(with string: String) -> NSDecimalNumber {
      return formatter.number(from: string) as? NSDecimalNumber ?? 0
    }
    
    for position in arrayOfEmployees {
      for employee in position {
        let hoursWorked = decimal(with: employee.hours)
        let positionWeight = decimal(with: employee.weight)
        employee.points = (hoursWorked as Decimal) * (positionWeight as Decimal)
        totalPoints = totalPoints + employee.points
        tipsPerPoint = totalTips / totalPoints
      }
    }
    for position in arrayOfEmployees {
      for employee in position {
        employee.tipsEarned = employee.points * tipsPerPoint
        
        let stringTips = String(format: "%.2f", Double(truncating: employee.tipsEarned as NSNumber))
        print("\(employee.name), hours \(employee.hours), position: \(employee.position), points: \(employee.points), tips: \(stringTips)")
      }
      // Running this print statement way too many times
      print("pointsTotal: \(totalPoints)")
      print("tipsPerPoint: \(tipsPerPoint)")
    }
    
    tableView.reloadData()
  }
  
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

