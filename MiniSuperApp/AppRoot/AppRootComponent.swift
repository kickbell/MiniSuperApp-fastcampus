//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/21/23.
//

import Foundation
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import ModernRIBs
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp
import Network
import NetworkImp


final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency, AddPaymentMethodDependency  {
  
  var superPayRepository: SuperPayRepository
  var cardOnFileRepository: CardOnFileRepository
  
  lazy var transportHomeBuildeable: TransportHomeBuildable = {
    return TransportHomeBuilder(dependency: self)
  }()
  
  lazy var topupBuildable: TopupBuildable = {
    return TopupBuilder(dependency: self)
  }()
  
  lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
    return AddPaymentMethodBuilder(dependency: self)
  }()
  
  var topupBaseViewController: ViewControllable { rootViewController.topViewControllable }
  
  private let rootViewController: ViewControllable
  
  init(
    dependency: AppRootDependency,
    rootViewController: ViewControllable
  ) {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [SuperAppURLProtocol.self]
    setupURLProtocol()
    
    let network = NetworkImp(session: URLSession(configuration: config))
    self.superPayRepository = SuperPayRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
    self.cardOnFileRepository = CardOnFileRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
    self.cardOnFileRepository.fetch()
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}
