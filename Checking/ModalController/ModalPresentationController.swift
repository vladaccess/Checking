//
//  ModalPresentationController.swift
//  Checking
//
//  Created by Краснокутский Владислав on 27.07.2022.
//

import UIKit

final public class ModalPresentationController: UIPresentationController {

	// MARK: - Properties

	private let shouldHideOnTap: Bool

	private lazy var blurView: UIVisualEffectView = {
		let blurEffectView = UIVisualEffectView()

		let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
		blurEffectView.addGestureRecognizer(recognizer)
		return blurEffectView
	}()

	private lazy var blurEffect: UIBlurEffect = {
		return UIBlurEffect(style: .dark)
	}()

	// MARK: - Init

	public init(presentedViewController: UIViewController,
				presenting presentingViewController: UIViewController?,
				shouldHideOnTap: Bool = false) {
		self.shouldHideOnTap = shouldHideOnTap
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
	}

	// MARK: - Lifecycle

	override public func presentationTransitionWillBegin() {
		guard let containerView = containerView else {
			return
		}
		containerView.addSubview(blurView)
		guard let coordinator = presentedViewController.transitionCoordinator else {
			blurView.effect = blurEffect
			return
		}

		coordinator.animate(alongsideTransition: { _ in
			self.blurView.effect = self.blurEffect
		})
	}

	public override func presentationTransitionDidEnd(_ completed: Bool) {
		guard !completed else {
			return
		}
		blurView.removeFromSuperview()
	}

	override public func dismissalTransitionWillBegin() {
		guard let coordinator = presentedViewController.transitionCoordinator else {
			blurView.effect = nil
			return
		}

		coordinator.animate(alongsideTransition: { _ in
			self.blurView.effect = nil
		})
	}

	override public func dismissalTransitionDidEnd(_ completed: Bool) {
		guard completed else {
			return
		}
		blurView.removeFromSuperview()
	}

	override public func containerViewWillLayoutSubviews() {
		guard let blurViewFrame = containerView?.bounds else {
			return
		}
		blurView.frame = blurViewFrame
	}

	// MARK: - Private

	@objc private func handleTap(recognizer: UITapGestureRecognizer) {
		guard shouldHideOnTap else {
			return
		}
		presentingViewController.dismiss(animated: true)
	}
}
