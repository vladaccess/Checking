//
//  OnboardingProgressBar.swift
//  Checking
//
//  Created by Краснокутский Владислав on 23.07.2022.
//

import UIKit

private struct BarSegment {
	static let height: CGFloat = 4.0
	static let indent: CGFloat = 5.0
}

struct ProgressElement {
	var showtime: TimeInterval
}

protocol OnboardingProgressBarProtocol {
	func pause()
	func resume()
	func goForward()
	func goBack()
	func reset()
	func resetCurrentSegment()
}

protocol OnboardingProgressBarDelegate: AnyObject {
	func elementDidFinishDisplay(at index: Int)
	func barDidFinishDisplay()
}

class OnboardingProgressBar: UIView {

	// MARK: - Properties

	weak var delegate: OnboardingProgressBarDelegate?

	// MARK: - Private properties

	private let progressElements: [ProgressElement]
	private let primaryColor: UIColor
	private let secondaryColor: UIColor
	private var segments: [ProgressBarSegmentProtocol] = []
	private var isPaused = false
	private var hasDoneLayout = false // To prevent from re-animation
	private var currentPageIndex: Int
	private var currentSegment: ProgressBarSegmentProtocol?

	// MARK: - Construction

	/// Configures ProgressBar with desiredFrame to display, and progressElements,
	/// to construct bar with some amount of segments, each of which will have
	/// time interval to show.
	/// - Parameters:
	///   - progressElements: The progress elements, each containing showtime values.
	init(progressElements: [ProgressElement], primaryColor: UIColor, secondaryColor: UIColor, startPageIndex: Int = 0) {
		self.progressElements = progressElements
		self.primaryColor = primaryColor
		self.secondaryColor = secondaryColor
		self.currentPageIndex = startPageIndex

		super.init(frame: .zero)

		setupSegments()

		paintedPreviousProgressElements()
	}

	private func paintedPreviousProgressElements() {
		guard currentPageIndex >= 0 && currentPageIndex < segments.count else {
			return
		}
		for index in 0..<currentPageIndex {
			segments[index].changeState(to: .filled)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View life cycle

	override func layoutSubviews() {
		super.layoutSubviews()

		if hasDoneLayout {
			return
		}

		hasDoneLayout = true
		startAnimation()
	}

	// MARK: - Private functions

	private func startAnimation() {
		guard currentSegment == nil, let segmentsItem = segments[safe: currentPageIndex] else {
			return
		}

		currentSegment = segmentsItem
		currentSegment?.changeState(to: .play)

		pauseIfNeeded()
	}

	private func setupSegments() {
		let segmentViews: [ProgressBarSegment] = progressElements.enumerated().map { (index, element) in
			let segment = ProgressBarSegment(progressElement: element,
											 primaryColor: primaryColor,
											 secondaryColor: secondaryColor)
			segment.tag = index
			segment.segmentDelegate = self

			return segment
		}

		self.segments = segmentViews

		let stackView = UIStackView(arrangedSubviews: segmentViews)
		stackView.spacing = BarSegment.indent
		stackView.distribution = .fillEqually
		addSubview(stackView)

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.heightAnchor.constraint(equalToConstant: BarSegment.height).isActive = true
		stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: BarSegment.height / 2).isActive = true
	}

	private func pauseIfNeeded() {
		if isPaused {
			currentSegment?.pauseAnimation()
		}
	}
}

extension OnboardingProgressBar: OnboardingProgressBarProtocol {

	func goForward() {
		currentPageIndex += 1

		switch currentSegment?.state {
		case .rewind:
			currentSegment?.changeState(to: .play)
		case .play:
			currentSegment?.changeState(to: .forward)
		default:
			break
		}

		pauseIfNeeded()
	}

	func goBack() {
		currentPageIndex -= 1

		switch currentSegment?.state {
		case .forward:
			currentSegment?.changeState(to: .play)
		case .play:
			currentSegment?.changeState(to: .rewind)
		default:
			break
		}

		pauseIfNeeded()
	}

	func pause() {
		isPaused = true
		currentSegment?.pauseAnimation()
	}

	func resume() {
		isPaused = false
		currentSegment?.resumeAnimation()
	}

	func reset() {
		for segment in segments {
			segment.changeState(to: .empty)
			if segment.tag == 0 {
				currentSegment = segment
			}
		}
		currentSegment?.changeState(to: .play)
	}

	func resetCurrentSegment() {
		if currentSegment == nil {
			currentSegment = segments.last
		}
		currentSegment?.changeState(to: .rewind)
	}
}

extension OnboardingProgressBar: ProgressBarSegmentDelegate {

	func segmentDidFinishAnimation(_ segment: ProgressBarSegmentProtocol, animationWasSkipped: Bool) {
		switch segment.state {
		case .play, .forward:
			if segment.state == .play, !animationWasSkipped {
				delegate?.elementDidFinishDisplay(at: segment.tag)
				if currentPageIndex + 1 < progressElements.count {
					currentPageIndex += 1
				} else {
					delegate?.barDidFinishDisplay()
					return
				}
			}

			while let nextSegment = currentSegment, nextSegment.tag < currentPageIndex {
				currentSegment?.changeState(to: .filled)
				currentSegment = segments[safe: nextSegment.tag + 1]
			}

			if let nextSegment = currentSegment {
				nextSegment.changeState(to: .play)
			}
		case .rewind:
			while let nextSegment = currentSegment, nextSegment.tag > currentPageIndex {
				currentSegment?.changeState(to: .empty)
				currentSegment = segments[safe: nextSegment.tag - 1]
			}

			currentSegment?.changeState(to: .empty)
			currentSegment?.changeState(to: .play)
		default:
			break
		}
	}
}

extension Collection {
	subscript (safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
