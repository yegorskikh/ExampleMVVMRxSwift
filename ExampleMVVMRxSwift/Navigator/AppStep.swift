//
//  AppStep.swift
//  ExampleMVVMRxSwift
//
//  Created by Yegor Gorskikh on 06.06.2022.
//

import RxFlow

enum AppStep: Step {
  case loginIsRequired
  case userIsLoggedIn
}
