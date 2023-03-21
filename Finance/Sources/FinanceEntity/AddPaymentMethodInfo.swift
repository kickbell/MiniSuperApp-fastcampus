//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/19/23.
//

import Foundation

public struct AddPaymentMethodInfo {
  public let number: String
  public let cvc: String
  public let expiration: String
  
  public init(
    number: String,
    cvc: String,
    expiration: String
  ) {
    self.number = number
    self.cvc = cvc
    self.expiration = expiration
  }
}
