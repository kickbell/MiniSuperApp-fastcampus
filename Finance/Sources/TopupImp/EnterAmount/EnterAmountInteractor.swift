//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/20/23.
//

import ModernRIBs
import Combine
import Foundation
import CombineUtil
import FinanceEntity
import FinanceRepository

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    func startLoading()
    func stopLoading()
}

protocol EnterAmountListener: AnyObject {
    func enterAmountDidTapClose()
    func enterAmountDidTapPaymentMethod()
    func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {

    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?
  
    private let dependency: EnterAmountInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: EnterAmountPresentable,
        dependencty: EnterAmountInteractorDependency
    ) {
        self.dependency = dependencty
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
      
        dependency.selectedPaymentMethod.sink { [weak self] paymentMethod in
          self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
  
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapPaymentMethod()
    }
  
    func didTapTopup(with amount: Double) {
      presenter.startLoading()
      
      dependency.superPayRepository.topup(
        amount: amount,
        paymentMethodID: dependency.selectedPaymentMethod.value.id
      )
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] _ in
          self?.presenter.stopLoading()
        },
        receiveValue: { [weak self] _ in
          self?.listener?.enterAmountDidFinishTopup()
        }
      ).store(in: &cancellables)
    }
  
}
