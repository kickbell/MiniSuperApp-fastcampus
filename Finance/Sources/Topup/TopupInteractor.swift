//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/20/23.
//

import ModernRIBs
import FinanceEntity
import FinanceRepository
import RIBsUtil
import SuperUI
import CombineUtil

protocol TopupRouting: Routing {
  func cleanupViews()
  
  func attachAddPaymentMethod(closeButtonType: DismissButtonType)
  func detachAddPaymentMethod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
  func popToRoot()
}

public protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFisish()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresentationControllerDelegate {
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  private var paymentMethods: [PaymentMethod] {
    dependency.cardOnFileRepository.cardOfFile.value
  }
  
  private let dependency: TopupInteractorDependency
  
  private var isEnterAmountRoot: Bool = false
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  init(
    dependency: TopupInteractorDependency
  ) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    self.dependency = dependency
    super.init()
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    if let card = dependency.cardOnFileRepository.cardOfFile.value.first {
      isEnterAmountRoot = true
      dependency.paymentMethodStream.send(card)
      router?.attachEnterAmount()
    } else {
      isEnterAmountRoot = false
      router?.attachAddPaymentMethod(closeButtonType: .close)
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
    // TODO: Pause any business logic.
  }
  
  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
    if isEnterAmountRoot == false {
      listener?.topupDidClose()
    }
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    dependency.paymentMethodStream.send(paymentMethod)
    
    if isEnterAmountRoot {
      router?.popToRoot()
    } else {
      isEnterAmountRoot = true
      router?.attachEnterAmount()
    }
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    router?.attachCardOnFile(paymentMethods: paymentMethods)
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    router?.attachAddPaymentMethod(closeButtonType: .back)
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymentMethods[safe: index] {
      dependency.paymentMethodStream.send(selected)
    }
    router?.detachCardOnFile()
  }
  
  func enterAmountDidFinishTopup() {
    listener?.topupDidFisish()
  }
}
