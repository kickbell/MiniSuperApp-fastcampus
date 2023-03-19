//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/19/23.
//

import UIKit

protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  
  weak var delegate: AdaptivePresentationControllerDelegate?
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
  
}
