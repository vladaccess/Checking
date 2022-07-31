//
//  TextFieldModePresenterProtocol.swift
//  Checking
//
//  Created by Краснокутский Владислав on 05.08.2022.
//

import UIKit

protocol TextFieldModePresenterProtocol {
	func setupTitleLabel(label: UILabel)
	func setupRightView(textField: UITextField)
	func textFieldDidChange(textField: UITextField)
}
