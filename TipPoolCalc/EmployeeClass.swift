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
  var weight: Decimal = 0.00
  var hours: Decimal = 0.00
  
  init(name: String = "", position: String = "", weight: Decimal = 0.00, hours: Decimal = 0.00) {
    self.name = name
    self.position = position
    self.weight = weight
    self.hours = hours
  }
}
