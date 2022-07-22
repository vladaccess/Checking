//
//  ModalController.swift
//  Checking
//
//  Created by Краснокутский Владислав on 27.07.2022.
//

import UIKit

open class ModalController: UIViewController {

	// MARK: - Constants

	private enum Consts {
		static let bottomImagePadding: CGFloat = 16
		static let sidePadding: CGFloat = 20
		static let topButtonPadding: CGFloat = 20
		static let messageLabelTopPadding: CGFloat = 8
		static let textFieldTopPadding: CGFloat = 16

		static let buttonsVerticalSpacing: CGFloat = 12
		static let buttonsHorizontalSpacing: CGFloat = 12

		static let presentDuration: TimeInterval = 0.3
		static let dismissDuration: TimeInterval = 0.2
		static let keyboardDuration: TimeInterval = 0.2
	}

	// MARK: - Views

	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
	
	lazy var containerView: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		return containerView
	}()

	// MARK: - Internal Properties

	public var leftContentConstraint: NSLayoutConstraint?
	public var rightContentConstraint: NSLayoutConstraint?
	var bottomContentConstraint: NSLayoutConstraint?

	var regularConstraints: [NSLayoutConstraint] = []
	var compactConstraints: [NSLayoutConstraint] = []

	// MARK: - Properties

	private var shouldHideOnBackgroundTap = true
	private var shouldHideOnSwipeDown = true

	private weak var sourceViewController: UIViewController?

	private var currentTranslationY: CGFloat = 0

	// MARK: - Init

	public init(shouldHideOnBackgroundTap: Bool = true,
				shouldHideOnSwipeDown: Bool = true) {
		super.init(nibName: nil, bundle: nil)

		self.shouldHideOnBackgroundTap = shouldHideOnBackgroundTap
		self.shouldHideOnSwipeDown = shouldHideOnSwipeDown

		transitioningDelegate = self
		modalPresentationStyle = .custom
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	open override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

		if shouldHideOnSwipeDown {
			let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
			view.addGestureRecognizer(gesture)
		}
	}

	@objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {

		let state = gestureRecognizer.state
		let translation = gestureRecognizer.translation(in: view)

		if state == .began {
			currentTranslationY = view.transform.ty
		} else if state == .changed {
			view.transform = CGAffineTransform(translationX: 0, y: max(translation.y + currentTranslationY, currentTranslationY))
		} else if state == .cancelled || state == .ended {

			let velocityY = gestureRecognizer.velocity(in: view).y

			if translation.y + velocityY > view.frame.height / 2 {
				dismiss(animated: true, completion: nil)
			} else {
				UIView.animate(withDuration: Consts.dismissDuration) {
					self.view.transform = CGAffineTransform(translationX: 0, y: self.currentTranslationY)
				}
			}
		}
	}
	
	func setupViews() {
		view.backgroundColor = .white

		setupScrollView()
		setupContainerView()
	}

	// MARK: - Layout

	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		activateSizeClassConstraints()
	}

	func activateSizeClassConstraints() {
		NSLayoutConstraint.deactivate(compactConstraints + regularConstraints)
		
		if traitCollection.verticalSizeClass == .regular {
			NSLayoutConstraint.activate(regularConstraints)
		} else {
			NSLayoutConstraint.activate(compactConstraints)
		}
	}
}

// MARK: - Private methods

private extension ModalController {

	func setupScrollView() {
		view.addSubview(scrollView)

		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	func setupContainerView() {
		scrollView.addSubview(containerView)

		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
		])

		let heightAnchor = view.heightAnchor.constraint(equalTo: containerView.heightAnchor)
		heightAnchor.priority = .defaultLow
		heightAnchor.isActive = true
	}

	// MARK: - Keyboard

	@objc func keyboardWillShow(_ notification:Notification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

			let yOffset = keyboardSize.height - (sourceViewController?.view.layoutMargins.bottom ?? 0)

			UIView.animate(withDuration: Consts.keyboardDuration) {
				self.view.transform = CGAffineTransform.init(translationX: 0, y: -yOffset )
			}
		}
	}

	@objc func keyboardWillHide(_ notification:Notification) {
		UIView.animate(withDuration: Consts.keyboardDuration) {
			self.view.transform = .identity
		}
	}
}

// MARK: - UIViewControllerTransitioningDelegate

extension ModalController: UIViewControllerTransitioningDelegate {
	public func presentationController(forPresented presented: UIViewController,
									   presenting: UIViewController?,
									   source: UIViewController) -> UIPresentationController? {
		sourceViewController = source
		
		return ModalPresentationController(presentedViewController: presented,
										   presenting: presenting,
										   shouldHideOnTap: shouldHideOnBackgroundTap)
	}
	
	public func animationController(forPresented presented: UIViewController,
									presenting: UIViewController,
									source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return ModalPresenter(duration: Consts.presentDuration)
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return ModalDismisser(duration: Consts.dismissDuration)
	}
}
