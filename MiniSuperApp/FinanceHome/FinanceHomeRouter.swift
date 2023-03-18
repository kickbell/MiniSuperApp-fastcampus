import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
  private let superPayDashboardBuildable: SuperPayDashboardBuildable
  private var superPayRouting: Routing?
  
  private let cardOnfileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnfileRouting: Routing?
  
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashboardBuildable: SuperPayDashboardBuildable,
    cardOnfileDashboardBuildable: CardOnFileDashboardBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnfileDashboardBuildable = cardOnfileDashboardBuildable
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
}
