//
//  TierTableViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 9/17/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class TierTableViewController: UITableViewController {
  
  
  @IBOutlet weak var positionTextField: UITextField!
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet var positionEntryStackView: UIStackView!
  
  
  var tierPositionArray = [String]()
  var tierWeightArray = [String]()
  
  var tiers: [NSManagedObject] = []
  
  var tiersArray: [TiersClass] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()

    // Nav bar background color (change view background in storyboard)
    navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "93827f")    //UIColor.flatForestGreen
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
    pinBackground(backgroundView, to: positionEntryStackView)

  }
  private lazy var backgroundView: UIView = {
    let view = UIView()
    
    // Employee entry background color
    view.backgroundColor = UIColor.init(hexString: "8ae0ad")
    
    return view
  }()
  
  private func pinBackground(_ view: UIView, to stackView: UIStackView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    stackView.insertSubview(view, at: 0)
    view.pin(to: stackView)
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
    
    tableView.reloadData()
  }
  

  
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tiers.count
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Positions"
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
    
    // Cell header background color
    
    //let cellColor = GradientColor(UIGradientStyle.leftToRight, frame: header.frame, colors: [UIColor(hexString: "4fd9bb")!, UIColor(hexString: "87e5d1")!])
    let header = view as! UITableViewHeaderFooterView
    
    view.tintColor =  GradientColor(UIGradientStyle.leftToRight, frame: header.frame, colors: [UIColor(hexString: "2ccaa7")!, UIColor(hexString: "4fd9bb")!]) //UIColor.init(hexString: "aa9d9b")   //UIColor.flatMint
    header.textLabel?.textColor = UIColor.black
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    tableView.separatorStyle = .singleLine
    
    let cellColor = UIColor.init(hexString: "d9d3d2")!
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let tier = tiers[indexPath.row]
    
    cell.textLabel?.text =  tier.value(forKey: "position") as? String  //"\(tierPositionArray[indexPath.row])"
    cell.detailTextLabel?.text = tier.value(forKey: "weight") as? String   //"\(tierWeightArray[indexPath.row])"
    
    cell.backgroundColor = cellColor
    
    cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
    cell.detailTextLabel?.backgroundColor = UIColor.clear
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      print("Deleted")
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tiers")
      
      context.delete(tiers[indexPath.row])
      // context.delete(tiersArray[indexPath.row])
      
      self.tiersArray.remove(at: indexPath.row) // crashes when delete row
      self.tiers.remove(at: indexPath.row)
      
      print("tiersArray deleted: \(tiersArray)")
      
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      
      do {
        try context.save()
        print("Deleted row...\(tiers)")
      } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
      }
    }
  }
  
  @IBAction func addTierButton(_ sender: UIButton) {
    
    if weightTextField.text! == "" {
      print("This isn't allowed to be blank")
      
    } else {
      
      if positionTextField.text! == "" {
        positionTextField.text = "\(tierPositionArray.count + 1)"

        let newTier = TiersClass(position: positionTextField.text!, weight: weightTextField.text!)

        tiersArray.append(newTier)
        print("tiersArray just added: \(tiersArray)")
        
        tierPositionArray.insert(positionTextField.text!, at: 0)
        tierWeightArray.insert(weightTextField.text!, at: 0)
        
      } else {
        
        let newTier = TiersClass(position: positionTextField.text!, weight: weightTextField.text!)
        
        tiersArray.append(newTier)
        print("tiersArray just added: \(tiersArray)")
        
        tierPositionArray.insert(positionTextField.text!, at: 0)
        tierWeightArray.insert(weightTextField.text!, at: 0)
        
      }
    }
    
    self.save(position: positionTextField.text!, weight: weightTextField.text!)
    
    for i in 0..<tierPositionArray.count {
      print("\(tierPositionArray[i]): \(tierWeightArray[i])")
      
    }
    positionTextField.text = ""
    weightTextField.text = ""
    
    tableView.reloadData()
  }
  
  func save(position: String, weight: String) {
    
    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    // 1
    let managedContext =
      appDelegate.persistentContainer.viewContext
    
    // 2
    let tier =
      NSEntityDescription.entity(forEntityName: "Tiers",
                                 in: managedContext)!
    
    let newTier = NSManagedObject(entity: tier,
                                  insertInto: managedContext)
    
    // 3
    newTier.setValue(position, forKey: "position")
    newTier.setValue(weight, forKey: "weight")
    
    // 4
    do {
      try managedContext.save()
      tiers.append(newTier)
      print("Saved to Core Data \(tiers), managedContext: \(managedContext)")
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

}
