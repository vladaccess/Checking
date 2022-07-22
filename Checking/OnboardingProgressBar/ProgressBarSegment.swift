//
//  ProgressBarSegment.swift
//  Checking
//
//  Created by Краснокутский Владислав on 23.07.2022.
//

import UIKit

protocol ProgressBarSegmentDelegate: AnyObject {
	func segmentDidFinishAnimation(_ segment: ProgressBarSegmentProtocol, animationWasSkipped: Bool)
}

protocol ProgressBarSegmentProtocol {

	var tag: Int { get }
	var state: ProgressBarSegmentState { get }

	func changeState(to state: ProgressBarSegmentState)
	func pauseAnimation()
	func resumeAnimation()
}

enum ProgressBarSegmentState {
	case empty
	case play
	case rewind
	case forward
	case filled
}

class ProgressBarSegment: UIView {

	// MARK: - Properties

	weak var segmentDelegate: ProgressBarSegmentDelegate?

	private(set) var state = ProgressBarSegmentState.empty

	// MARK: - Private properties

	private let strokeEnd = "strokeEnd"
	private let layerAnimation = "layerAnimation"
	private let progressElement: ProgressElement
	private let primaryColor: UIColor
	private let secondaryColor: UIColor
	private let animationLayer = CAShapeLayer()

	private var currentPosition: Double {
		animationLayer.presentation()?.value(forKey: strokeEnd) as? Double ?? 0
	}

	// MARK: - Construction

	init(progressElement: ProgressElement, primaryColor: UIColor, secondaryColor: UIColor) {
		self.progressElement = progressElement
		self.primaryColor = primaryColor
		self.secondaryColor = secondaryColor
		super.init(frame: .zero)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View life cycle

	override func draw(_ rect: CGRect) {
		let path = linePath(rect)
		secondaryColor.setStroke()
		path.stroke()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		animationLayer.path = linePath(bounds).cgPath
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		animationLayer.strokeColor = primaryColor.cgColor
	}

	// MARK: - Private functions

	private func setup() {
		isOpaque = false
		layer.addSublayer(animationLayer)

		animationLayer.strokeColor = primaryColor.cgColor
		animationLayer.strokeEnd = 0
		animationLayer.lineWidth = 4
		animationLayer.lineCap = .round
	}

	private func playAnimation() {
		let position = state == .empty ? 0 : currentPosition
		let animation = CABasicAnimation(keyPath: strokeEnd)
		animation.fromValue = position
		animation.toValue = 1.0
		animation.fillMode = .forwards
		animation.duration = progressElement.showtime - position * progressElement.showtime
		animation.isRemovedOnCompletion = false
		animation.delegate = self

		animationLayer.strokeEnd = CGFloat(position)
		animationLayer.add(animation, forKey: layerAnimation)
	}

	private func skipAnimation() {
		let position = state == .empty ? 0 : currentPosition
		animationLayer.removeAllAnimations()
		animationLayer.strokeEnd = CGFloat(position)
		DispatchQueue.main.async {
			self.segmentDelegate?.segmentDidFinishAnimation(self, animationWasSkipped: true)
		}
	}

	private func applyFixedStroke(painted: Bool) {
		animationLayer.strokeEnd = painted ? 1.0 : 0.0
		animationLayer.removeAllAnimations()
	}

	private func linePath(_ rect: CGRect) -> UIBezierPath {
		// Setting inset because "lineCapStyle = .round"
		// adds rounded caps at the endings of the line.
		let drawRect = rect.insetBy(dx: bounds.height / 2, dy: 1)
		let startPoint = CGPoint(x: drawRect.minX, y: drawRect.midY)
		let endPoint = CGPoint(x: drawRect.maxX, y: drawRect.midY)

		let path = UIBezierPath()
		path.lineWidth = bounds.height
		path.lineCapStyle = .round
		path.move(to: startPoint)
		path.addLine(to: endPoint)

		return path
	}
}

extension ProgressBarSegment: ProgressBarSegmentProtocol {

	func changeState(to state: ProgressBarSegmentState) {
		switch state {
		case .empty:
			applyFixedStroke(painted: false)
		case .play:
			playAnimation()
		case .rewind, .forward:
			skipAnimation()
		case .filled:
			applyFixedStroke(painted: true)
		}

		self.state = state
	}

	func pauseAnimation() {
		animationLayer.strokeEnd = CGFloat(currentPosition)
		animationLayer.removeAllAnimations()
	}

	func resumeAnimation() {
		changeState(to: state)
	}
}

extension ProgressBarSegment: CAAnimationDelegate {
	func animationDidStop(_ anim: CAAnimation, finished: Bool) {
		if finished {
			segmentDelegate?.segmentDidFinishAnimation(self, animationWasSkipped: false)
		}
	}
}

