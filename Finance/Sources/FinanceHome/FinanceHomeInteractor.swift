import ModernRIBs
import UIKit
import SuperUI
import FinanceEntity

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashboard()
  func attachSuperCardOnFileDashboard()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod() //화면내릴때
  func attachTopup()
  func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentationControllerDelegate {
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: FinanceHomePresentable) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    router?.attachSuperPayDashboard()
    router?.attachSuperCardOnFileDashboard()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func cardOnFileDashboardDidTapAddPaymentMethod() {
    router?.attachAddPaymentMethod()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
  }
  
  func presentationControllerDidDismiss() {
    router?.detachAddPaymentMethod()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    router?.detachAddPaymentMethod()
  }
  
  func superPayDashboardDidTapTopup() {
    router?.attachTopup()
  }
  
  func topupDidClose() {
    router?.detachTopup()
  }
  
  func topupDidFisish() {
    router?.detachTopup()
  }
}
