//
//  FormsViewController.swift
//  Checking
//
//  Created by Краснокутский Владислав on 06.08.2022.
//

import Foundation
import UIKit

class FormsViewController: UIViewController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		title = "Формы"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(editing))
		view.addGestureRecognizer(tap)
		
		let textField = TextFieldAnimated()
		textField.mode = .clearMode
		textField.subtitleText = "Поле с подписью"
		textField.titleText = "Label"
		textField.placeholder = "Placeholder"
		view.addSubview(textField)
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
	}
	
	@objc func editing() {
		view.endEditing(true)
	}
}
