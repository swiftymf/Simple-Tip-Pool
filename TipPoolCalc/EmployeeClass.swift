//
//  EmployeeClass.swift
//  TipPoolCalc
//
//  Created by Markith on 9/19/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import Foundation

class Employee {
  var name: String = ""
  var position: String = ""
  var weight: String = ""
  var hours: String = ""
  var points: Decimal = 0.00
  var tipsEarned: Decimal = 0.00
  
  init(name: String = "", position: String = "", weight: String = "", hours: String = "") {
    self.name = name
    self.position = position
    self.weight = weight
    self.hours = hours
  }
}
