//
//  TierTableViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 9/17/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit
import CoreData
import PKHUD
import SkyFloatingLabelTextField

class TierTableViewController: UITableViewController {
  
  @IBOutlet weak var positionTextField: SkyFloatingNotCurrencyTextField!
  @IBOutlet weak var weightTextField: SkyFloatingNotCurrencyTextField!
  @IBOutlet var positionEntryStackView: UIStackView!
  
  
  var tierPositionArray = [String]()
  var tierWeightArray = [String]()
  
  var tiers: [NSManagedObject] = []
  
  var tiersArray: [TiersClass] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSAttributedString.Key.foregroundColor: UIColor.white,
       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .light)]
    
    tableView.backgroundView = UIImageView(image: UIImage(named: "gradientbg"))
    
    positionTextField.lineColor = UIColor.white
    weightTextField.lineColor = UIColor.white
    positionTextField.placeholderColor = UIColor.white
    weightTextField.placeholderColor = UIColor.white
    
    self.tableView.tableFooterView = UIView()

  }
  
  @IBAction func infoButtonTapped(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "", message: "1. Enter Cash and Credit card tips\n\n2. Enter % for support staff\n(ignore if using points system)\n\n3. Choose Split Hourly or\nSplit by Points\n\n4. Enter employee name and hours worked\n\n5. Choose server or support for hourly split or select position if splitting by points\n\n- As you add employees, tips will be calculated automatically\n\n- If splitting by points, you will first create the positions and assign point values in this screen.\n\n- The app will remember positions for future use. Swipe to delete if needed.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nil))
    
    self.present(alert, animated: true)
  }
  
//  private func pinBackground(_ view: UIView, to stackView: UIStackView) {
//    view.translatesAutoresizingMaskIntoConstraints = false
//    stackView.insertSubview(view, at: 0)
//    view.pin(to: stackView)
//  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tiersArray.removeAll()
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tiers")
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
    let header = view as! UITableViewHeaderFooterView
    view.tintColor =  UIColor.clear
    header.textLabel?.textColor = UIColor.black
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    tableView.separatorStyle = .singleLine
    
    let cellColor = UIColor.clear  //UIColor.init(hexString: "d9d3d2")!
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let tier = tiers[indexPath.row]
    
    cell.textLabel?.text =  tier.value(forKey: "position") as? String  //"\(tierPositionArray[indexPath.row])"
    cell.detailTextLabel?.text = tier.value(forKey: "weight") as? String   //"\(tierWeightArray[indexPath.row])"
    
    cell.backgroundColor = cellColor
    
    //cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
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
    
    if weightTextField.text?.isEmpty ?? true {
      print("This isn't allowed to be blank \(weightTextField.text!)")
      HUD.flash(.error, delay: 1.0)
      
    } else {
      
      if positionTextField.text! == "" {
        positionTextField.text = "\(tierPositionArray.count + 1)"
        
        let newTier = TiersClass(position: positionTextField.text!, weight: weightTextField.text!)
        
        tiersArray.append(newTier)
        print("tiersArray just added: \(tiersArray)")
        
        tierPositionArray.insert(positionTextField.text!, at: 0)
        tierWeightArray.insert(weightTextField.text!, at: 0)
        
        self.save(position: positionTextField.text!, weight: weightTextField.text!)
        
        for i in 0..<tierPositionArray.count {
          print("\(tierPositionArray[i]): \(tierWeightArray[i])")
        }
        
      } else {
        
        let newTier = TiersClass(position: positionTextField.text!, weight: weightTextField.text!)
        
        tiersArray.append(newTier)
        print("tiersArray just added: \(tiersArray)")
        
        tierPositionArray.insert(positionTextField.text!, at: 0)
        tierWeightArray.insert(weightTextField.text!, at: 0)
        
        self.save(position: positionTextField.text!, weight: weightTextField.text!)
        
        for i in 0..<tierPositionArray.count {
          print("\(tierPositionArray[i]): \(tierWeightArray[i])")
        }
        HUD.flash(.success, delay: 1.0)
      }
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
