//
//  ModalDismisser.swift
//  Checking
//
//  Created by Краснокутский Владислав on 27.07.2022.
//

import UIKit

final class ModalDismisser: NSObject, UIViewControllerAnimatedTransitioning {

	// MARK: - Properties
	
	private let duration: TimeInterval

	// MARK: - Init

	init(duration: TimeInterval) {
		self.duration = duration
		super.init()
	}

	// MARK: - UIViewControllerAnimatedTransitioning

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let container = transitionContext.containerView

		guard let fromView = transitionContext.view(forKey: .from) else {
			transitionContext.completeTransition(false)
			return
		}

		let translation = container.layoutMargins.bottom + fromView.frame.height

		UIView.animate(withDuration: transitionDuration(using: transitionContext),
					   delay: 0,
					   options: .curveEaseOut) {
			fromView.transform = CGAffineTransform(translationX: 0,
												   y: translation)
		} completion: { _ in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
	}
}
