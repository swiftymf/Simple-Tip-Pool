//
//  QuickSplitViewController.swift
//  TipPoolCalc
//
//  Created by Markith on 9/27/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import UIKit

class QuickSplitViewController: UIViewController {
  
  var totalTips: Decimal = 0.00
  var totalTipsForLabel = ""
  var percentageIsCash: Decimal = 0.00
  var barbackSplitPercentage: Decimal = 0.00


  @IBOutlet weak var numberOfBartendersTextField: UITextField!
  @IBOutlet weak var numberOfBarbacksTextField: UITextField!
  @IBOutlet weak var bartenderTipsSplitLabel: UILabel!
  @IBOutlet weak var barbackTipSplitLabel: UILabel!
  @IBOutlet weak var totalTipsLabel: UILabel!
  
  override func viewDidLoad() {
    
        super.viewDidLoad()
    totalTipsLabel.text = totalTipsForLabel
    
    }
    

  @IBAction func calculateTipsButtonPressed(_ sender: UIButton) {

    let numberOfBartenders = Decimal(Int(numberOfBartendersTextField.text!)!)
    let numberOfBarbacks = Decimal(Int(numberOfBarbacksTextField.text!)!)
    
    let barbackSplit = totalTips * (barbackSplitPercentage / 100)
    
    let tipsForEachBartender = ((totalTips - barbackSplit) / numberOfBartenders)
    let tipsForEachBarback = (barbackSplit / numberOfBarbacks)
    
    bartenderTipsSplitLabel.text = "$\(String(format: "%.2f", Double(truncating: tipsForEachBartender as NSNumber)))"
    barbackTipSplitLabel.text = "$\(String(format: "%.2f", Double(truncating: tipsForEachBarback as NSNumber)))"

    //bartenderTipsSplitLabel.text = "\(tipsForEachBartender)"
    //barbackTipSplitLabel.text = "\(tipsForEachBarback)"
    
   // print("cash tips: \(cashTips), credit tips: \(creditTips), total tips: \(totalTips), number bartenders: \(numberOfBartenders), number barbacks: \(numberOfBarbacks), % for barbacks: \(barbackSplitPercentage), $ for barbacks: \(barbackSplit)")
    
    
  }
  

}
