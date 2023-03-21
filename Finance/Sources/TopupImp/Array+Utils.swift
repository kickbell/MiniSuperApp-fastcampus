//
//  File.swift
//  
//
//  Created by jc.kim on 3/21/23.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
