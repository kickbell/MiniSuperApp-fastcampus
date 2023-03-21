//
//  SuperPayDashboardRouter.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/19/23.
//

import ModernRIBs

protocol SuperPayDashboardInteractable: Interactable {
    var router: SuperPayDashboardRouting? { get set }
    var listener: SuperPayDashboardListener? { get set }
}

protocol SuperPayDashboardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SuperPayDashboardRouter: ViewableRouter<SuperPayDashboardInteractable, SuperPayDashboardViewControllable>, SuperPayDashboardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SuperPayDashboardInteractable, viewController: SuperPayDashboardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
