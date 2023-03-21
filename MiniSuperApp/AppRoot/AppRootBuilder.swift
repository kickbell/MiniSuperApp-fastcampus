import ModernRIBs
import UIKit
import FinanceRepository
import FinanceHome
import AppHome
import ProfileHome

protocol AppRootDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency  {
  var superPayRepository: SuperPayRepository
  var cardOnFileRepository: CardOnFileRepository
  
  init(
    dependency: AppRootDependency,
    superPayRepository: SuperPayRepository,
    cardOnFileRepository: CardOnFileRepository
  ) {
    self.superPayRepository = superPayRepository
    self.cardOnFileRepository = cardOnFileRepository
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
  func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler)
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
  
  override init(dependency: AppRootDependency) {
    super.init(dependency: dependency)
  }
  
  func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler) {
    let component = AppRootComponent(
      dependency: dependency,
      superPayRepository: SuperPayRepositoryImp(),
      cardOnFileRepository: CardOnFileRepositoryImp()
    )
    
    let tabBar = RootTabBarController()
    
    let interactor = AppRootInteractor(presenter: tabBar)
    
    let appHome = AppHomeBuilder(dependency: component)
    let financeHome = FinanceHomeBuilder(dependency: component)
    let profileHome = ProfileHomeBuilder(dependency: component)
    let router = AppRootRouter(
      interactor: interactor,
      viewController: tabBar,
      appHome: appHome,
      financeHome: financeHome,
      profileHome: profileHome
    )
    
    return (router, interactor)
  }
}
