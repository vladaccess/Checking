//
//  ExampleModalController.swift
//  Checking
//
//  Created by Краснокутский Владислав on 27.07.2022.
//

import Foundation
import UIKit

class ExampleModalController: ModalController {
	
	let redView = UIView()
	
	override func setupViews() {
		super.setupViews()
		
		redView.translatesAutoresizingMaskIntoConstraints = false
		redView.backgroundColor = .red.withAlphaComponent(0.5)
		containerView.addSubview(redView)
		redView.heightAnchor.constraint(equalToConstant: 200).isActive = true
		redView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		redView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		redView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		redView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
	}
}
