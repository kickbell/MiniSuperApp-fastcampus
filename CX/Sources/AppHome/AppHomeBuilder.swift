import ModernRIBs
import FinanceRepository
import TransportHome

public protocol AppHomeDependency: Dependency {
  var superPayRepository: SuperPayRepository { get }
  var cardOnFileRepository: CardOnFileRepository { get }
  var transportHomeBuildeable: TransportHomeBuildable { get }
}

final class AppHomeComponent: Component<AppHomeDependency> {
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var transportHomeBuildeable: TransportHomeBuildable { dependency.transportHomeBuildeable }
}

// MARK: - Builder

public protocol AppHomeBuildable: Buildable {
  func build(withListener listener: AppHomeListener) -> ViewableRouting
}

public final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable {
  
  public override init(dependency: AppHomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: AppHomeListener) -> ViewableRouting {
    let component = AppHomeComponent(dependency: dependency)
    let viewController = AppHomeViewController()
    let interactor = AppHomeInteractor(presenter: viewController)
    interactor.listener = listener
        
    return AppHomeRouter(
      interactor: interactor,
      viewController: viewController,
      transportHomeBuildable: component.transportHomeBuildeable
    )
  }
}
