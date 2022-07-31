//
//  SecureModePresenter.swift
//  Checking
//
//  Created by Краснокутский Владислав on 05.08.2022.
//

import UIKit

extension TextFieldMode {
	struct SecureModePresenter: TextFieldModePresenterProtocol {

		// MARK: - Constants

		enum Constants {
			static let rightInset: CGFloat = 12
		}

		// MARK: - Public properties

		func setupTitleLabel(label: UILabel) {}

		func textFieldDidChange(textField: UITextField) {}

		func setupRightView(textField: UITextField) {
			let eyeButton = ButtonBase()
			setupButtonImage(button: eyeButton,
							 isSecure: textField.isSecureTextEntry)
			eyeButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: Constants.rightInset)

			eyeButton.touchUpAction = { _ in
				textField.isSecureTextEntry = !textField.isSecureTextEntry
				setupButtonImage(button: eyeButton,
								 isSecure: textField.isSecureTextEntry)
			}

			textField.rightView = eyeButton
			textField.rightViewMode = .always

			textField.setNeedsLayout()
		}

		// MARK: - Private properties

		private func setupButtonImage(button: UIButton, isSecure: Bool) {
			let eyeImage = UIImage(named: "icEye")
			let eyeCrossedImage = UIImage(named: "icEyeCrossed")
			let icon = isSecure ? eyeImage : eyeCrossedImage
			button.setImage(icon, for: .normal)
		}
	}
}
