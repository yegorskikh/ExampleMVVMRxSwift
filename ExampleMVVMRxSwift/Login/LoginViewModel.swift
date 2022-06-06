//
//  LoginViewModel.swift
//  ExampleMVVMRxSwift
//
//  Created by Yegor Gorskikh on 06.06.2022.
//

import Foundation
import RxFlow
import RxRelay
import RxCocoa
import RxSwift

class LoginViewModel: ViewModelProtocol, Stepper {

  private let disposeBag = DisposeBag()

  let steps = PublishRelay<Step>()

  let input: Input
  let output: Output

  struct Input {
    let onEmailChanged: AnyObserver<String>
    let onPasswordChanged: AnyObserver<String>
    let onSendAction: AnyObserver<Void>
  }

  struct Output {
    let isEmailValid: Driver<Bool>
    let isSendButtonEnabled: Driver<Bool>
  }

  // Input
  private let email = BehaviorSubject(value: "")
  private let password = BehaviorSubject(value: "")
  private let sendAction = PublishSubject<Void>()

  // Output
  private let isEmailValid = BehaviorSubject(value: true)
  private let isSendButtonEnabled = BehaviorSubject(value: false)

  init() {
    input = Input(
      onEmailChanged: email.asObserver(),
      onPasswordChanged: password.asObserver(),
      onSendAction: sendAction.asObserver()
    )
    output = Output(
      isEmailValid: isEmailValid.asDriver(onErrorJustReturn: false),
      isSendButtonEnabled: isSendButtonEnabled.asDriver(onErrorJustReturn: false)
    )

    initBindings()
  }

  private func initBindings() {
    email
      .map { email -> Bool in email.contains("@") }
      .bind(to: isEmailValid)
      .disposed(by: disposeBag)

    Observable
      .combineLatest(isEmailValid, password)
      .map { isEmailValid, password in isEmailValid && !password.isEmpty}
      .bind(to: isSendButtonEnabled)
      .disposed(by: disposeBag)

    sendAction
      .withLatestFrom(
        Observable.combineLatest(email, password, isEmailValid)
      )
      .filter { _, _, isEmailValid in isEmailValid }
      .bind { [weak self] email, password, _ in
        guard let self = self else { return }

        self.sendData(
          email: email,
          password: password
        ) { comleted in
          if comleted {
            self.steps.accept(AppStep.userIsLoggedIn)
          } else {
            print("Something terrible happened")
          }
        }
      }
      .disposed(by: disposeBag)
  }

  // MOCK
  private func sendData(
    email: String,
    password: String,
    comletion: @escaping (Bool) -> Void
  ) {
    DispatchQueue.global().async {
      sleep(5)
      print("email: \(email), password: \(password)")
      DispatchQueue.main.async {
        comletion(true)
      }
    }
  }
}
