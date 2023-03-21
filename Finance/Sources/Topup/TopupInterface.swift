//
//  File.swift
//  
//
//  Created by jc.kim on 3/21/23.
//

import Foundation
import ModernRIBs

public protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFisish()
}
