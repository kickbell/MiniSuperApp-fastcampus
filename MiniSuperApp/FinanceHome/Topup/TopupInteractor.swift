//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/20/23.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
  
  private let dependency: TopupInteractorDependency

    init(
      dependency: TopupInteractorDependency
    ) {
      self.dependency = dependency
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
}
