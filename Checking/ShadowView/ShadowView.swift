//
//  ShadowView.swift
//  Checking
//
//  Created by Краснокутский Владислав on 31.07.2022.
//

import UIKit
/// Отображение тени с возможностью скругления углов
class ShadowView: UIView {

	// MARK: - Public properties
	
	var cornerRadius: CGFloat {
		get { _cornerRadius }
		set { _cornerRadius = newValue }
	}

	/// Контейнер для контента внутри карточки
	public let contentView: UIView = {
		let view = UIView()
		view.isUserInteractionEnabled = false
		view.layer.masksToBounds = true
		return view
	}()

	// MARK: - Private properties

	private var perimeterShadowLayer: CALayer?
	private var dropShadowLayer: CALayer?
	private var _cornerRadius: CGFloat = 16 { didSet { updateCornerRadius() } }

	// MARK: - Lifecycle

	public init() {
		super.init(frame: .zero)
		setupView()
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}

	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		addShadowsIfNeeded()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		perimeterShadowLayer?.frame = bounds
		dropShadowLayer?.frame = bounds
	}

	// MARK: - Private Methods

	private func setupView() {
		backgroundColor = .clear

		contentView.backgroundColor = .white
		addSubview(contentView)
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		
		addShadowsIfNeeded()
		
		updateCornerRadius()
	}

	private func addShadowsIfNeeded() {
		perimeterShadowLayer?.removeFromSuperlayer()
		dropShadowLayer?.removeFromSuperlayer()

		let perimeterShadowLayer = CALayer()
		perimeterShadowLayer.shadowOpacity = 0.04
		perimeterShadowLayer.shadowRadius = 10
		perimeterShadowLayer.shadowOffset = .zero
		perimeterShadowLayer.needsDisplayOnBoundsChange = true
		
		let dropShadowLayer = CALayer()
		dropShadowLayer.shadowOpacity = 0.04
		dropShadowLayer.shadowRadius = 10
		dropShadowLayer.shadowOffset = CGSize(width: 0, height: 8)
		dropShadowLayer.needsDisplayOnBoundsChange = true
		
		perimeterShadowLayer.backgroundColor = UIColor.white.cgColor
		perimeterShadowLayer.shadowColor = UIColor.black.cgColor
		
		dropShadowLayer.backgroundColor = UIColor.white.cgColor
		dropShadowLayer.shadowColor = UIColor.black.cgColor
		
		perimeterShadowLayer.frame = bounds
		dropShadowLayer.frame = bounds
		
		layer.insertSublayer(perimeterShadowLayer, at: 0)
		layer.insertSublayer(dropShadowLayer, above: perimeterShadowLayer)
		
		self.perimeterShadowLayer = perimeterShadowLayer
		self.dropShadowLayer = dropShadowLayer
	}
	
	private func updateCornerRadius() {
		contentView.layer.cornerRadius = _cornerRadius
		layer.cornerRadius = _cornerRadius
		perimeterShadowLayer?.cornerRadius = _cornerRadius
		dropShadowLayer?.cornerRadius = _cornerRadius
	}
}
