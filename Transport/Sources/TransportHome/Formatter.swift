//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/21/23.
//

import Foundation

struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
}
