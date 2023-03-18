//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/19/23.
//

//import RIBs
import ModernRIBs
//import RxSwift
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {

    weak var listener: CardOnFileDashboardPresentableListener?
}
