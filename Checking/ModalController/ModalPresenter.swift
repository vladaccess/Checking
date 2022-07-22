//
//  ModalPresenter.swift
//  Checking
//
//  Created by Краснокутский Владислав on 27.07.2022.
//

import UIKit

final class ModalPresenter: NSObject, UIViewControllerAnimatedTransitioning {

	// MARK: - Consts
	
	private enum Consts {
		static let widthToView: CGFloat = 375
		static let cornerRadiusToView: CGFloat = 20.0
		static let sidePadding: CGFloat = 8.0
		static let springDamping: CGFloat = 0.7
		static let initialSpringVelocity: CGFloat = 1
	}

	// MARK: - Properties

	private let duration: TimeInterval
	private weak var toView: UIView?

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

		guard let toView = transitionContext.view(forKey: .to),
			  let toVC = transitionContext.viewController(forKey: .to) as? ModalController,
			  let fromVC = transitionContext.viewController(forKey: .from) else {
			transitionContext.completeTransition(false)
			return
		}

		setupLayout(container: container,
					toView: toView,
					toVC: toVC,
					fromVC: fromVC)

		toView.transform = CGAffineTransform(translationX: 0, y: container.frame.height - toView.frame.minY)
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn) {
			toView.transform = .identity
		} completion: { completed in
			transitionContext.completeTransition(completed)
		}
	}

	// MARK: - Private

	private func setupLayout(container: UIView,
							 toView: UIView,
							 toVC: ModalController,
							 fromVC: UIViewController) {
		toView.layer.masksToBounds = true
		toView.layer.cornerRadius = Consts.cornerRadiusToView
		toView.translatesAutoresizingMaskIntoConstraints = false

		container.addSubview(toView)

		let bottomOffset = fromVC.view.layoutMargins.bottom + Consts.sidePadding

		let widthConstraint = toView.widthAnchor.constraint(equalToConstant: Consts.widthToView)
		let sideConstraint = toView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: Consts.sidePadding)

		toVC.regularConstraints = [sideConstraint]
		toVC.compactConstraints = [widthConstraint]

		toView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
		toView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -bottomOffset).isActive = true
	}
}
