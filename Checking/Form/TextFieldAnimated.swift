//
//  TextFieldAnimated.swift
//  Checking
//
//  Created by Краснокутский Владислав on 05.08.2022.
//

import UIKit

open class TextFieldAnimated: UITextField {

	// MARK: - Constants

	private enum Constants {
		static let textFieldHeight: CGFloat = 44
		static let subtitleTopOffset: CGFloat = 12
		static let lineTopOffset: CGFloat = 7
		static let titleMinScale: CGFloat = 0.8
		static let animationDuration: TimeInterval = 0.2
	}

	// MARK: - Public properties

	/// Режим отображения
	public var mode: TextFieldMode = .none {
		didSet {
			switch mode {
			case .none:
				modePresenter = nil
			case .readOnly:
				modePresenter = TextFieldMode.ReadOnlyPresenter()
			case .secureMode:
				modePresenter = TextFieldMode.SecureModePresenter()
			case .clearMode:
				modePresenter = TextFieldMode.ClearModePresenter()
			}

			resetState()
			modePresenter?.setupRightView(textField: self)
		}
	}

	/// Текст ошибки
	/// Отображается под полем ввода
	public var errorText: String?  {
		didSet {
			updateTitleLabel()
			updateSubtitleLabel()
			updateLineView()
			setNeedsLayout()
			setNeedsDisplay()
		}
	}

	/// Текст над полем ввода
	public var titleText: String? {
		didSet {
			updateTitleLabel()
			setNeedsLayout()
			setNeedsDisplay()
		}
	}

	/// Текст под полем ввода
	public var subtitleText: String? {
		didSet {
			updateSubtitleLabel()
			setNeedsLayout()
			setNeedsDisplay()
		}
	}

	// MARK: - Private properties

	/// Кеш для плейсхолдера
	private var _placeholderString: NSAttributedString? = nil

	/// Текст, который отобразится под текстфилдом
	private var subtitleVisibleText: String? {
		errorText ?? subtitleText
	}

	private var modePresenter: TextFieldModePresenterProtocol?

	private let lineView: UIView = {
		let line = UIView()
		line.isUserInteractionEnabled = false
		return line
	}()

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17)
		label.textColor = .black
		label.numberOfLines = 1
		label.lineBreakMode = .byClipping
		label.autoresizingMask = .flexibleWidth
		label.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
		return label
	}()

	private var subtitleLabel: UILabel?

	// MARK: - Overriden properties

	open override var isSecureTextEntry: Bool {
		didSet {
			if mode == .secureMode {
				modePresenter?.setupRightView(textField: self)
			}
		}
	}

	open override var placeholder: String? {
		didSet {
			updatePlaceholderCache()
			setPlaceholderHidden(!isFirstResponder)
		}
	}

	// MARK: - Respondering

	open override func becomeFirstResponder() -> Bool {
		if mode == .readOnly {
			return false
		}
		if super.becomeFirstResponder() {
			updateLineView()
			return true
		}
		return false
	}

	open override func resignFirstResponder() -> Bool {
		if super.resignFirstResponder() {
			updateLineView()
			return true
		}
		return false
	}

	// MARK: - Initializers

	override public init(frame: CGRect) {
		super.init(frame: frame)
		initView()
	}

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		initView()
	}

	// MARK: - Rendering

	open override func draw(_ rect: CGRect) {
		super.draw(rect)
		layoutTitleLabel()
	}

	open override func didMoveToSuperview() {
		super.didMoveToSuperview()
		layoutTitleLabel()
	}

	// MARK: - Public methods

	public func updatePlaceholderCache(_ attrString: NSAttributedString? = nil) {
		_placeholderString = attrString ?? attributedPlaceholder
	}

	// MARK: - Layout

	open override var intrinsicContentSize: CGSize {
		let bottomHeight = subtitleRect().height == 0 ? underlineOffset() : subtitleRect().height + Constants.subtitleTopOffset

		return .init(width: bounds.width, height: Constants.textFieldHeight + bottomHeight)
	}

	open override func layoutSubviews() {
		super.layoutSubviews()
		invalidateIntrinsicContentSize()
		subtitleLabel?.frame = subtitleRect()
		updateLineView()
	}

	// MARK: - Layout rects

	private func titleTopRect() -> CGRect {
		guard let attrStr = titleLabel.attributedText, !attrStr.string.isEmpty else {
			return .zero
		}

		let size = CGSize(width: bounds.size.width, height: 0)
		let boundingRect = attrStr.boundingRect(with: size,
												options: [.usesLineFragmentOrigin, .usesFontLeading],
												context: nil)
		return CGRect(x: 0,
					  y: 0,
					  width: ceil(boundingRect.width),
					  height: ceil(boundingRect.height))
	}

	private func titleDownRect() -> CGRect {
		return CGRect(x: 0,
					  y: 0,
					  width: bounds.size.width,
					  height: Constants.textFieldHeight)
	}

	private func subtitleRect() -> CGRect {
		guard let l2 = subtitleLabel, let l2text = l2.text, !l2text.isEmpty else {
			return .zero
		}
		let font: UIFont = l2.font ?? UIFont.systemFont(ofSize: 17.0)

		let textAttributes = [NSAttributedString.Key.font: font]
		let size = CGSize(width: bounds.size.width, height: 0)
		let boundingRect = l2text.boundingRect(with: size,
											   options: [.usesLineFragmentOrigin, .usesFontLeading],
											   attributes: textAttributes,
											   context: nil)

		let rect = CGRect(x: 0,
						  y: Constants.textFieldHeight + Constants.subtitleTopOffset,
						  width: ceil(boundingRect.width),
						  height: ceil(boundingRect.height))
		return rect
	}

	// MARK: - Drawing and positioning overrides

	open override func textRect(forBounds bounds: CGRect) -> CGRect {
		var rect =  super.textRect(forBounds: bounds)
		updateTextRect(&rect)
		return rect
	}

	open override func editingRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.editingRect(forBounds: bounds)
		updateTextRect(&rect)
		return rect
	}

	open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return editingRect(forBounds: bounds)
	}

	open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.rightViewRect(forBounds: bounds)
		rect.origin.y = Constants.textFieldHeight/2 - rect.height/2
		return rect
	}

	open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.clearButtonRect(forBounds: bounds)
		rect.origin.y = Constants.textFieldHeight/2 - rect.height/2
		return rect
	}

	// MARK: - Private methods

	private func resetState() {
		rightView = nil
		leftView = nil
		updateTitleLabel()
		updateSubtitleLabel()
		updateLineView()
		setNeedsLayout()
		setNeedsDisplay()
	}

	private func initView() {
		borderStyle = .none
		tintColor = .black

		addSubview(titleLabel)
		addSubview(lineView)
		createSubtitleIfNeeded()

		addTarget(self, action: #selector(editingChanged), for: .editingChanged)
		addTarget(self, action: #selector(beginEdit), for: .editingDidBegin)
		addTarget(self, action: #selector(endEdit), for: .editingDidEnd)

		setPlaceholderHidden(true)
	}

	private func setPlaceholderHidden(_ isHidden: Bool) {
		attributedPlaceholder = isHidden ? nil : _placeholderString
	}

	private func updateTitleLabel() {
		titleLabel.text = titleText
		titleLabel.textColor = titleColor()

		modePresenter?.setupTitleLabel(label: titleLabel)
	}

	private func layoutTitleLabel() {
		if let text = text, !text.isEmpty {
			liftTitleUp(animated: false)
		} else if isFirstResponder {
			liftTitleUp(animated: false)
		} else {
			pullTitleDown(animated: false)
		}
	}

	private func createSubtitleIfNeeded() {
		let shouldShowSubtitle = !(subtitleVisibleText ?? "").isEmpty
		guard shouldShowSubtitle, subtitleLabel == nil else {
			return
		}

		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.textColor = .black
		label.numberOfLines = 0
		self.subtitleLabel = label
		addSubview(label)
	}

	private func updateSubtitleLabel() {
		createSubtitleIfNeeded()
		subtitleLabel?.text = subtitleVisibleText
		subtitleLabel?.textColor = titleColor()
	}

	private func updateLineView() {
		let textRect = textRect(forBounds: bounds)
		lineView.frame = CGRect(x: 0,
								y: textRect.origin.y + textRect.height + Constants.lineTopOffset,
								width: bounds.width,
								height: 1)
		lineView.backgroundColor = lineViewColor()
	}

	private func underlineOffset() -> CGFloat {
		return lineView.bounds.height + Constants.lineTopOffset
	}

	private func updateTextRect(_ rect: inout CGRect) {
		let h1 = ceil(titleTopRect().height * Constants.titleMinScale)
		rect.origin.y = h1
		rect.size.height -= h1

		let h2 = subtitleRect().height == 0 ? underlineOffset() : (subtitleRect().height + Constants.subtitleTopOffset)
		rect.size.height -= h2
	}

	// MARK: - Colors

	private func titleColor() -> UIColor {
		if !(errorText ?? "").isEmpty {
			return .red
		}
		return .black
	}

	private func lineViewColor() -> UIColor {
		if !(errorText ?? "").isEmpty {
			return .red
		}
		return isFirstResponder ? .blue : .gray
	}

	// MARK: - Animations

	private func liftTitleUp(animated: Bool) {
		let duration = animated ? Constants.animationDuration : 0
		UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
			self.titleLabel.frame = self.titleTopRect()
			self.titleLabel.transform = CGAffineTransform(scaleX: Constants.titleMinScale,
														  y: Constants.titleMinScale)
		}) { _ in
			self.setPlaceholderHidden(!self.isFirstResponder)
		}
	}

	private func pullTitleDown(animated: Bool) {
		let duration = animated ? Constants.animationDuration : 0
		setPlaceholderHidden(true)
		UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
			self.titleLabel.transform = .identity
			self.titleLabel.frame = self.titleDownRect()
		})
	}

	// MARK: - Events actions

	@objc private func beginEdit() {
		liftTitleUp(animated: true)
	}

	@objc private func endEdit() {
		if let text = text, !text.isEmpty {
			return
		}
		pullTitleDown(animated: true)
	}

	@objc private func editingChanged() {
		modePresenter?.textFieldDidChange(textField: self)
	}
}
