//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by jc.kim on 3/19/23.
//

import Foundation

protocol CardOnFileRepository {
  var cardOfFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
  var cardOfFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
  
  private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
    PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
    PaymentMethod(id: "1", name: "신한카드", digits: "0545", color: "#3478f6ff", isPrimary: false),
    PaymentMethod(id: "2", name: "현대카드", digits: "5445", color: "#78c5f5ff", isPrimary: false),
    PaymentMethod(id: "3", name: "국민은행", digits: "3775", color: "#65c466ff", isPrimary: false),
    PaymentMethod(id: "4", name: "카카오뱅크", digits: "4554", color: "#ffcc00ff", isPrimary: false)
  ])
}


