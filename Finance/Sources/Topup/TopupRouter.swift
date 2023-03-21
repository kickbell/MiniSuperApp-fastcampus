//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/20/23.
//

import ModernRIBs
import AddPaymentMethod
import SuperUI
import RIBsUtil
import FinanceEntity

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
  var router: TopupRouting? { get set }
  var listener: TopupListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
  // this RIB does not own its own view, this protocol is conformed to by one of this
  // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  private let enterAmountBuildable: EnterAmountBuildable
  private var enterAmountRouting: EnterAmountRouting?
  
  private let cardOnFileBuildable: CardOnFileBuildable
  private var cardOnFileRouting: CardOnFileRouting?
  
  private var navigationControllable: NavigationControllerable?
  
  init(
    interactor: TopupInteractable,
    viewController: ViewControllable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    enterAmountBuildable: EnterAmountBuildable,
    cardOnFileBuildable: CardOnFileBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.enterAmountBuildable = enterAmountBuildable
    self.cardOnFileBuildable = cardOnFileBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {
    if viewController.uiviewController.presentationController != nil {
      viewController.dismiss(completion: nil)
    }
  }
  
  // MARK: - Private
  
  private let viewController: ViewControllable
  
  func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
    if addPaymentMethodRouting != nil {
      return
    }

    let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)

    if let navigationControllable = navigationControllable {
      navigationControllable.pushViewController(router.viewControllable, animated: true)
    } else {
      presentInsideNavigation(router.viewControllable)
    }

    attachChild(router)
    addPaymentMethodRouting = router
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    
    navigationControllable?.popViewController(animated: true)
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
  func attachEnterAmount() {
    if enterAmountRouting != nil {
      return
    }
    
    let router = enterAmountBuildable.build(withListener: interactor)
    
    //네비게이션 스택을 날리고 푸시하려고 한다.
    if let navigation = navigationControllable {
      navigation.setViewControllers([router.viewControllable])
      resetChildRouting()
    } else {
      //그게 아닌 경우는 모달로 띄운다.
      //presentInsideNavigation 이 안에 네비게이션이 있어.
      //이게먼저 실행되면 네비게이션컨트롤러블이 nil이 아니다.
      presentInsideNavigation(router.viewControllable)
    }
    
    //이미 네비게이션이 있으니까 이것만 해줘도 푸시가 되나보다?
    attachChild(router)
    enterAmountRouting = router
  }
  
  func detachEnterAmount() {
    guard let router = enterAmountRouting else {
      return
    }
    
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    enterAmountRouting = nil
  }
  
  func attachCardOnFile(paymentMethods: [PaymentMethod]) {
    if cardOnFileRouting != nil {
      return
    }
    
    let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
    navigationControllable?.pushViewController(router.viewControllable, animated: true)
    cardOnFileRouting = router
    attachChild(router)
  }
  
  func detachCardOnFile() {
    guard let router = cardOnFileRouting else {
      return
    }
    
    navigationControllable?.popViewController(animated: true)
    detachChild(router)
    cardOnFileRouting = nil
  }
  
  func popToRoot() {
    navigationControllable?.popToRoot(animated: true)
    resetChildRouting()
  }
  
  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    self.navigationControllable = navigation
    
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    if self.navigationControllable == nil {
      return
    }
    
    viewController.dismiss(completion: nil)
    self.navigationControllable = nil
  }
  
  private func resetChildRouting() {
    if let cardOnFileRouting = cardOnFileRouting {
      detachChild(cardOnFileRouting)
      self.cardOnFileRouting = nil
    }
    
    if let addPaymentMethodRouting = addPaymentMethodRouting {
      detachChild(addPaymentMethodRouting)
      self.addPaymentMethodRouting = nil
    }
  }
  
}
