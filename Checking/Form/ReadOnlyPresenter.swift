//
//  ReadOnlyPresenter.swift
//  Checking
//
//  Created by Краснокутский Владислав on 05.08.2022.
//

import UIKit

extension TextFieldMode {
	struct ReadOnlyPresenter: TextFieldModePresenterProtocol {

		// MARK: - Constants

		enum Constants {
			static let copiedText = "Текст скопирован"
			static let rightInset: CGFloat = 12
		}

		// MARK: - Public properties

		func setupTitleLabel(label: UILabel) {
			label.addLockerIcon(iconColor: label.textColor)
		}

		func setupRightView(textField: UITextField) {
			textField.endEditing(true)

			let copyButton = ButtonBase()
			let copyImage = UIImage(named: "icCopyText")
			copyButton.setImage(copyImage, for: .normal)
			copyButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: Constants.rightInset)
			textField.rightViewMode = .always

			textField.setNeedsLayout()
		}

		func textFieldDidChange(textField: UITextField) {}
	}
}
