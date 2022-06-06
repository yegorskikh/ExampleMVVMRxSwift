//
//  ViewController.swift
//  ExampleMVVMRxSwift
//
//  Created by Yegor Gorskikh on 05.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
  private let disposeBag = DisposeBag()

  var viewModel: LoginViewModel!

  @IBOutlet weak var txtEmail: UITextField!
  @IBOutlet weak var txtPassword: UITextField!
  @IBOutlet weak var btnSend: UIButton!
  @IBOutlet weak var emailValidationView: ValidationView!

  init() {
    super.init(nibName: String(describing: LoginViewController.self), bundle: .main)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    initBindings()
  }

  private func initBindings() {
    txtEmail.rx.text
      .orEmpty
      .bind(to: viewModel.input.onEmailChanged)
      .disposed(by: disposeBag)

    txtPassword.rx.text
      .orEmpty
      .bind(to: viewModel.input.onPasswordChanged)
      .disposed(by: disposeBag)

    btnSend.rx.tap
      .bind(to: viewModel.input.onSendAction)
      .disposed(by: disposeBag)

    viewModel.output.isEmailValid
      .drive(emailValidationView.rx.isValid)
      .disposed(by: disposeBag)

    viewModel.output.isSendButtonEnabled
      .drive(btnSend.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}


