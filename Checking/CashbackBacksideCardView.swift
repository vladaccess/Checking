//
//  CashbackView.swift
//  Checking
//
//  Created by Краснокутский Владислав on 22.08.2022.
//

import Foundation

@objcMembers
public final class CashbackBacksideCardView: UIView {

	// MARK: - Properties

	public typealias VoidClosure = (() -> Void)

	public var expirationDate: String? {
		didSet { updateUI() }
	}

	public var cardNumber: String? {
		didSet { updateUI() }
	}

	public var cvc: String? {
		didSet { updateUI() }
	}

	public var onDidHideData: VoidClosure?
	public var onDidCopyCardNumber: VoidClosure?
	public var onDidShowCVC: VoidClosure?
	public var onDidHideCVC: VoidClosure?

	// MARK: - Private properties

	private let hideDataButton = Button(style: .ghost, size: .s)
	private let stackView = UIStackView()
	private let cardNumberView = CardComponentView()
	private let expirationDateView = CardComponentView()
	private let cvcView = CardComponentView()

	private var secureTextEntry = true

	// MARK: - Construction

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private methods

	private func setupView() {
		backgroundColor = Color.backgroundPrimaryElevated

		hideDataButton.setTitle("Скрыть данные", for: .normal)
		hideDataButton.setTitleColor(Color.textPrimaryLink, for: .normal)
		addSubview(hideDataButton)
		hideDataButton.autoPinEdge(toSuperviewEdge: .leading, withInset: Grid.pt4)
		hideDataButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: Grid.pt8)
		hideDataButton.pressUpAction = { [weak self] _ in
			self?.onDidHideData?()
		}

		cardNumberView.rightIcon = UIImage.sdkImageNamed("ic_copy")
		cardNumberView.onRightIconDidClick = { [weak self] in
			self?.onDidCopyCardNumber?()

			MTSToast.show(MTSToastData(text: "Номер карты скопирован", icon: .done))
		}
		addSubview(cardNumberView)
		cardNumberView.autoPinEdge(toSuperviewEdge: .leading, withInset: Grid.pt16)
		cardNumberView.autoPinEdge(toSuperviewEdge: .trailing, withInset: Grid.pt16)
		cardNumberView.autoPinEdge(toSuperviewEdge: .top, withInset: Grid.pt16)
		cardNumberView.autoSetDimension(.height, toSize: Grid.pt28)

		stackView.axis = .horizontal
		stackView.spacing = Grid.pt8
		stackView.distribution = .fillEqually
		addSubview(stackView)
		stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: Grid.pt16)
		stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: Grid.pt16)
		stackView.autoPinEdge(.top, to: .bottom, of: cardNumberView, withOffset: Grid.pt8)
		stackView.autoSetDimension(.height, toSize: Grid.pt28)

		stackView.addArrangedSubview(expirationDateView)

		cvcView.primaryText = "CVC2"
		cvcView.primaryTextColor = Color.textSecondary
		cvcView.onRightIconDidClick = { [weak self] in
			self?.onDidClickCvcView()
		}
		stackView.addArrangedSubview(cvcView)

		updateUI()
	}

	private func updateUI() {
		expirationDateView.primaryText = expirationDate
		cardNumberView.primaryText = cardNumber
		updateCvcView()
	}

	private func onDidClickCvcView() {
		secureTextEntry.toggle()

		secureTextEntry ? onDidHideCVC?() : onDidShowCVC?()

		updateCvcView()
	}

	private func updateCvcView() {
		if secureTextEntry {
			cvcView.secondaryText = "•••"
			cvcView.rightIcon = { #imageLiteral(resourceName: "ic_visibility") }()
		} else {
			cvcView.secondaryText = cvc
			cvcView.rightIcon = { #imageLiteral(resourceName: "ic_visibility_off") }()
		}
	}
}
