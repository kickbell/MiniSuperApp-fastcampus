//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/19/23.
//

import ModernRIBs
import UIKit

protocol AddPaymentMethodPresentableListener: AnyObject {
  func didTapClose()
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {
  
  weak var listener: AddPaymentMethodPresentableListener?
    
  private let cardNumberTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "카드 번호"
    return textField
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = 14
    return stackView
  }()
  
  private let securityTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "CVC"
    return textField
  }()
  
  private let expirationTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "유효기한"
    return textField
  }()
  
  private lazy var addCardButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.roundCorners()
    button.backgroundColor = .primaryRed
    button.setTitle("추가하기", for: .normal)
    button.addTarget(self, action: #selector(didTapAddCard), for: .touchUpInside)
    return button
  }()
  
  private static func makeTextField() -> UITextField {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = .white
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    return textField
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  func setupViews() {
    title = "카드 추가"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(
        systemName: "xmark",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
      ),
      style: .plain,
      target: self,
      action: #selector(didTapClose)
    )
    view.backgroundColor = .white
    view.addSubview(cardNumberTextField)
    view.addSubview(stackView)
    view.addSubview(addCardButton)
    
    stackView.addArrangedSubview(securityTextField)
    stackView.addArrangedSubview(expirationTextField)
    
    NSLayoutConstraint.activate([
      cardNumberTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
      cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      cardNumberTextField.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
      
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      stackView.bottomAnchor.constraint(equalTo: addCardButton.topAnchor, constant: -20),
      
      addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      
      cardNumberTextField.heightAnchor.constraint(equalToConstant: 60),
      securityTextField.heightAnchor.constraint(equalToConstant: 60),
      expirationTextField.heightAnchor.constraint(equalToConstant: 60),
      addCardButton.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  @objc
  private func didTapAddCard() {
    
  }
  
  @objc
  private func didTapClose() {
    listener?.didTapClose()
  }
}
