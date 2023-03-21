//
//  File.swift
//  
//
//  Created by jc.kim on 3/21/23.
//

import Foundation
import ModernRIBs

public protocol TransportHomeBuildable: Buildable {
  func build(withListener listener: TransportHomeListener) -> ViewableRouting
}

public protocol TransportHomeListener: AnyObject {
  func transportHomeDidTapClose()
}
