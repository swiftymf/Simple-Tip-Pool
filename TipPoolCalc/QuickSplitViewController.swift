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
  
  private lazy var backgroundView: UIView = {
    let view = UIView()
    
    // Employee entry background color
    view.backgroundColor = UIColor.init(hexString: "8ae0ad")
    
    return view
  }()

  @IBAction func calculateTipsButtonPressed(_ sender: UIButton) {

    let formatter = NumberFormatter()
    formatter.generatesDecimalNumbers = true
    
    func decimal(with string: String) -> NSDecimalNumber {
      return formatter.number(from: string) as? NSDecimalNumber ?? 0
    }
    
    let numberOfBartenders: Decimal = decimal(with: numberOfBartendersTextField.text!) as Decimal
    let numberOfBarbacks = decimal(with: numberOfBarbacksTextField.text!) as Decimal
    
    let barbackSplit = totalTips * (barbackSplitPercentage / 100)
    let bartenderSplit = totalTips - barbackSplit
    
    let tipsForEachBartender = ((totalTips - barbackSplit) / numberOfBartenders)
    let tipsForEachBarback = (barbackSplit / numberOfBarbacks)

    
    bartenderTipsSplitLabel.text = "$\(String(format: "%.2f", Double(truncating: tipsForEachBartender as NSNumber))) ($\(String(format: "%.2f", Double(truncating: bartenderSplit as NSNumber))))"
    barbackTipSplitLabel.text = "$\(String(format: "%.2f", Double(truncating: tipsForEachBarback as NSNumber))) ($\(String(format: "%.2f", Double(truncating: barbackSplit as NSNumber))))"

  }

}
