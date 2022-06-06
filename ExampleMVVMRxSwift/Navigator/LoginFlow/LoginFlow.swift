//
//  LoginFlow.swift
//  ExampleMVVMRxSwift
//
//  Created by Yegor Gorskikh on 06.06.2022.
//

import Foundation
import RxFlow
import UIKit

class LoginFlow: Flow {
  private let window: UIWindow

  var root: Presentable {
    return self.rootViewController
  }

  init(window: UIWindow) {
    self.window = window
  }

  private let rootViewController = UINavigationController()

  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? AppStep else { return .none}

    switch step {
    case .loginIsRequired:
      return navigateToLogin()
    case .userIsLoggedIn:
      return showSuccessAlert()
    }
  }

  private func navigateToLogin() -> FlowContributors {
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()

    let loginViewModel = LoginViewModel()
    let loginVc = LoginViewController()
    loginVc.viewModel = loginViewModel

    rootViewController.viewControllers = [loginVc]
    return .one(
      flowContributor: .contribute(
        withNextPresentable: loginVc,
        withNextStepper: loginViewModel
      )
    )
  }

  private func showSuccessAlert() -> FlowContributors {
    let alert = UIAlertController(
      title: "Login Success",
      message: "User is successfully logged in",
      preferredStyle: .alert
    )
    let dismissAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(dismissAction)

    rootViewController.present(alert, animated: true, completion: nil)

    return .none
  }
}
