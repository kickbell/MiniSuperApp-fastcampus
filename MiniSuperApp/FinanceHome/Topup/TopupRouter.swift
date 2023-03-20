//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/20/23.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener {
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

    init(
      interactor: TopupInteractable,
      viewController: ViewControllable,
      addPaymentMethodBuildable: AddPaymentMethodBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
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
  
    //헬퍼메소드 필요없는 것 같아서 삭제.18분쯤. 필요하면 다시 적도록.
    func attachAddPaymentMethod() {
      if addPaymentMethodRouting != nil {
        return
      }
      
      let router = addPaymentMethodBuildable.build(withListener: interactor)
      let navigation = NavigationControllerable(root: router.viewControllable)
      navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
      viewController.present(navigation, animated: true, completion: nil)
      
      self.addPaymentMethodRouting = router
      attachChild(router)
    }
    
    func detachAddPaymentMethod() {
      guard let router = addPaymentMethodRouting else {
        return
      }
      
      viewController.dismiss(completion: nil)
      detachChild(router)
      addPaymentMethodRouting = nil
    }
  
}
