//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/19/23.
//

import Foundation
import UIKit
import FinanceEntity

struct PaymentMethodViewModel {
  let name: String
  let digits: String
  let color: UIColor
  
  init(_ paymentMethod: PaymentMethod) {
    name = paymentMethod.name
    digits = "**** \(paymentMethod.digits)"
    color = UIColor.init(hex: paymentMethod.color) ?? .systemGray2
  }
}
