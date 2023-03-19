import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
  private let superPayDashboardBuildable: SuperPayDashboardBuildable
  private var superPayRouting: Routing?
  
  private let cardOnfileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnfileRouting: Routing?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashboardBuildable: SuperPayDashboardBuildable,
    cardOnfileDashboardBuildable: CardOnFileDashboardBuildable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnfileDashboardBuildable = cardOnfileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachSuperPayDashboard() {
    if superPayRouting != nil {
      return
    }
    
    let router = superPayDashboardBuildable.build(withListener: interactor)

    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.superPayRouting = router
    attachChild(router)
  }
  
  func attachSuperCardOnFileDashboard() {
    if cardOnfileRouting != nil {
      return
    }
    
    let router = cardOnfileDashboardBuildable.build(withListener: interactor)
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.cardOnfileRouting = router
    attachChild(router)
  }
  
  func attachAddPaymentMethod() {
    if addPaymentMethodRouting != nil {
      return
    }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    let navigation = NavigationControllerable(root: router.viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    viewControllable.present(navigation, animated: true, completion: nil)
    
    self.addPaymentMethodRouting = router
    attachChild(router)
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    
    viewControllable.dismiss(completion: nil)
    
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
}
