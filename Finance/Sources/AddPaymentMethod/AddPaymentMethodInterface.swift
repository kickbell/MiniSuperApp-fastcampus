//
//  File.swift
//  
//
//  Created by jc.kim on 3/21/23.
//

import Foundation
import ModernRIBs
import FinanceEntity
import RIBsUtil

public protocol AddPaymentMethodBuildable: Buildable {
  func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting
}

public protocol AddPaymentMethodListener: AnyObject {
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}
