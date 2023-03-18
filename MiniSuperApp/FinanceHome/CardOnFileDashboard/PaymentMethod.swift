//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/19/23.
//

import Foundation

struct PaymentMethod: Decodable {
  let id: String
  let name: String
  let digits: String
  let color: String
  let isPrimary: Bool
}
