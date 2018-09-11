//
//  WeightedViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 9/9/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit
import CurrencyTextField
import ChameleonFramework

class WeightedViewController: UITableViewController {
  
  var shareText = Array<String>()

  
  
  @IBOutlet weak var tier1WeightTextField: UITextField!
  @IBOutlet weak var tier2WeightTextField: UITextField!
  @IBOutlet weak var tier3WeightTextField: UITextField!
  @IBOutlet weak var tier4WeightTextField: UITextField!
  
  @IBOutlet weak var employeeNameTextField: UITextField!
  @IBOutlet weak var hoursWorkedTextField: UITextField!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Nav bar color (change empty table area background in storyboard -> identity inspector
    navigationController?.navigationBar.barTintColor =  UIColor.init(hexString: "93827f")
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
  }
  
  private lazy var backgroundView: UIView = {
    let view = UIView()
    
    // Employee entry background color
    view.backgroundColor = UIColor.init(hexString: "8ae0ad")
    return view
    
  }()
  

  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 4
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
    
    // Cell header background color
    
    //let cellColor = GradientColor(UIGradientStyle.leftToRight, frame: header.frame, colors: [UIColor(hexString: "4fd9bb")!, UIColor(hexString: "87e5d1")!])
    let header = view as! UITableViewHeaderFooterView
    
    view.tintColor =  GradientColor(UIGradientStyle.leftToRight, frame: header.frame, colors: [UIColor(hexString: "2ccaa7")!, UIColor(hexString: "4fd9bb")!]) //UIColor.init(hexString: "aa9d9b")   //UIColor.flatMint
    header.textLabel?.textColor = UIColor.black
  }
  
  //  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  //    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
  //
  //    tableView.separatorStyle = .singleLine
  //
  //    let cellColor = UIColor.init(hexString: "d9d3d2")!
  //
  //    if indexPath.section == 0 {
  //      let nameAndHours = "\(serverArray[indexPath.row]) worked \(serverHours[indexPath.row]) hours. "
  //      let payoutText = serverPayoutText[indexPath.row]
  //      cell.textLabel?.text = "\(serverArray[indexPath.row]): \(serverHours[indexPath.row]) hours"
  //      cell.detailTextLabel?.text = payoutText
  //
  //      shareText.append("(Server) \(nameAndHours) \(payoutText)\n")
  //
  //      cell.backgroundColor = cellColor
  //
  //      cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
  //      cell.detailTextLabel?.backgroundColor = UIColor.clear
  //
  //    } else {
  //
  //      let nameAndHours = "\(barbackArray[indexPath.row]) worked \(barbackHours[indexPath.row]) hours. "
  //      cell.textLabel?.text  = "\(barbackArray[indexPath.row]): \(barbackHours[indexPath.row]) hours"
  //      let payoutText = barbackPayoutText[indexPath.row]
  //      cell.detailTextLabel?.text = payoutText
  //
  //      shareText.append("(Barback) \(nameAndHours) \(payoutText)\n")
  //
  //
  //      cell.backgroundColor = cellColor
  //
  //      cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
  //      cell.detailTextLabel?.backgroundColor = UIColor.clear
  //
  //    }
  //    return cell
  //
  //  }
  
  
  @IBAction func tier1ButtonPressed(_ sender: UIButton) {
  }
  
  @IBAction func tier2ButtonPressed(_ sender: UIButton) {
  }
  
  @IBAction func tier3ButtonPressed(_ sender: UIButton) {
  }
  
  @IBAction func tier4ButtonPressed(_ sender: UIButton) {
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


