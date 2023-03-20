import ModernRIBs

protocol TransportHomeDependency: Dependency {
  var superPayRepository: SuperPayRepository { get }
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency, TopupDependency {
  let topupBaseViewController: ViewControllable
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
  
  init(
    dependency: TransportHomeDependency,
    topupBaseViewController: ViewControllable
  ) {
    self.topupBaseViewController = topupBaseViewController
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol TransportHomeBuildable: Buildable {
  func build(withListener listener: TransportHomeListener) -> TransportHomeRouting
}

final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
  
  override init(dependency: TransportHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TransportHomeListener) -> TransportHomeRouting {
    let viewController = TransportHomeViewController()
    let component = TransportHomeComponent(dependency: dependency, topupBaseViewController: viewController)
    
    let interactor = TransportHomeInteractor(presenter: viewController, dependency: component)
    interactor.listener = listener
    
    let topupBuildable = TopupBuilder(dependency: component)
    
    return TransportHomeRouter(
      interactor: interactor,
      viewController: viewController,
      topupBuildable: topupBuildable
    )
  }
}
