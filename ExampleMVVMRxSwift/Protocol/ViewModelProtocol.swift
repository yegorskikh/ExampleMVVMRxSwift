//
//  Protocol.swift
//  ExampleMVVMRxSwift
//
//  Created by Yegor Gorskikh on 06.06.2022.
//

import Foundation

protocol ViewModelProtocol {
  associatedtype Input
  associatedtype Output

  var input: Input { get }
  var output: Output { get }
}
