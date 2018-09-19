//
//  TiersClass.swift
//  TipPoolCalc
//
//  Created by Markith on 9/19/18.
//  Copyright © 2018 SwiftyMF. All rights reserved.
//

import Foundation
import CoreData

class TiersClass {
  
  var position: String = ""
  var weight: Int = 0
  
  init(position: String, weight: Int) {
    self.position = position
    self.weight = weight
  }
}
