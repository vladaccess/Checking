//
//  ViewController.swift
//  Checking
//
//  Created by Краснокутский Владислав on 22.07.2022.
//

import UIKit

class ViewController: UIViewController {
	
	private let progressBarView = OnboardingProgressBar(progressElements: [ProgressElement(showtime: 5),
																		   ProgressElement(showtime: 5),
																		   ProgressElement(showtime: 5),
																		   ProgressElement(showtime: 5)],
														primaryColor: .black,
														secondaryColor: .lightGray)
	private let pauseButton = UIButton()
	private let resumeButton = UIButton()
	private let resetButton = UIButton()
	private let goForwardButton = UIButton()
	private let goBackButton = UIButton()
	private let openModalScreenButton = UIButton()
	private let shadowView = ShadowView()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(progressBarView)
		progressBarView.translatesAutoresizingMaskIntoConstraints = false
		progressBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		progressBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		progressBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
		
		view.addSubview(pauseButton)
		pauseButton.setTitle("Pause", for: .normal)
		pauseButton.backgroundColor = .cyan
		pauseButton.translatesAutoresizingMaskIntoConstraints = false
		pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		pauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
		pauseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		pauseButton.addTarget(nil, action: #selector(onPauseButtonDidClick), for: .touchUpInside)
		
		view.addSubview(resumeButton)
		resumeButton.backgroundColor = .cyan
		resumeButton.setTitle("Resume", for: .normal)
		resumeButton.translatesAutoresizingMaskIntoConstraints = false
		resumeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		resumeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		resumeButton.bottomAnchor.constraint(equalTo: pauseButton.topAnchor, constant: -24).isActive = true
		resumeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		resumeButton.addTarget(nil, action: #selector(onResumeButtonDidClick), for: .touchUpInside)
		
		view.addSubview(resetButton)
		resetButton.backgroundColor = .cyan
		resetButton.setTitle("Reset", for: .normal)
		resetButton.translatesAutoresizingMaskIntoConstraints = false
		resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		resetButton.bottomAnchor.constraint(equalTo: resumeButton.topAnchor, constant: -24).isActive = true
		resetButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		resetButton.addTarget(nil, action: #selector(onResetButtonDidClick), for: .touchUpInside)
		
		view.addSubview(goForwardButton)
		goForwardButton.backgroundColor = .cyan
		goForwardButton.setTitle("Go Forward", for: .normal)
		goForwardButton.translatesAutoresizingMaskIntoConstraints = false
		goForwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		goForwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		goForwardButton.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -24).isActive = true
		goForwardButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		goForwardButton.addTarget(nil, action: #selector(onGoForwardButtonDidClick), for: .touchUpInside)
		
		view.addSubview(goBackButton)
		goBackButton.backgroundColor = .cyan
		goBackButton.setTitle("Go Back", for: .normal)
		goBackButton.translatesAutoresizingMaskIntoConstraints = false
		goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		goBackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		goBackButton.bottomAnchor.constraint(equalTo: goForwardButton.topAnchor, constant: -24).isActive = true
		goBackButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		goBackButton.addTarget(nil, action: #selector(onGoBackButtonDidClick), for: .touchUpInside)
		
		view.addSubview(openModalScreenButton)
		openModalScreenButton.backgroundColor = .cyan
		openModalScreenButton.setTitle("Open Modal Screen", for: .normal)
		openModalScreenButton.translatesAutoresizingMaskIntoConstraints = false
		openModalScreenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		openModalScreenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		openModalScreenButton.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: -24).isActive = true
		openModalScreenButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		openModalScreenButton.addTarget(nil, action: #selector(onOpenModalScreenButtonDidClick), for: .touchUpInside)
		
		view.addSubview(shadowView)
		shadowView.translatesAutoresizingMaskIntoConstraints = false
		shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
		shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
		shadowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
		shadowView.heightAnchor.constraint(equalToConstant: 100).isActive = true
	}
	
	@objc func onPauseButtonDidClick() {
		progressBarView.pause()
	}
	
	@objc func onResumeButtonDidClick() {
		progressBarView.resume()
	}
	
	@objc func onResetButtonDidClick() {
		progressBarView.reset()
	}
	
	@objc func onGoForwardButtonDidClick() {
		progressBarView.goForward()
	}
	
	@objc func onGoBackButtonDidClick() {
		progressBarView.goBack()
	}
	
	@objc func onOpenModalScreenButtonDidClick() {
		present(ExampleModalController(shouldHideOnBackgroundTap: true, shouldHideOnSwipeDown: true), animated: true)
	}
}
