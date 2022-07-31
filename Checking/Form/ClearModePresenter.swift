//
//  ClearModePresenter.swift
//  Checking
//
//  Created by Краснокутский Владислав on 05.08.2022.
//

import UIKit

extension TextFieldMode {
	struct ClearModePresenter: TextFieldModePresenterProtocol {
		
		// MARK: - Constants
		
		enum Constants {
			static let rightInset: CGFloat = 12
		}
		
		// MARK: - Public properties
		
		func setupTitleLabel(label: UILabel) {}
		
		func setupRightView(textField: UITextField) {
			let clearButton = ButtonBase()
			let clearImage = UIImage(named: "icClear")
			clearButton.setImage(clearImage, for: .normal)
			clearButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: Constants.rightInset)
			
			clearButton.touchUpAction = { _ in
				let shouldClear = textField.delegate?.textFieldShouldClear?(textField) ?? true
				if shouldClear {
					textField.text = nil
					textField.rightView = nil
					textField.sendActions(for: .editingChanged)
				}
			}
			
			textField.rightView = clearButton
			textField.rightViewMode = .whileEditing
			
			textField.setNeedsLayout()
		}
		
		func textFieldDidChange(textField: UITextField) {
			setupRightView(textField: textField)
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
