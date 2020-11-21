//
//  LoadingViewController.swift
//  WWA
//
//  Created by Borko Tomic on 14/04/2020.
//  Copyright © 2020 Borko Tomic. All rights reserved.
//

import Lottie
import UIKit

extension SwiftyCore.UI {
    class LoadingViewController: UIViewController {
        static public var animationFileName: String?
        static public var finishAnimationFileName: String?
        
        @IBOutlet weak private var animationViewPlaceholder: UIView!
        private var animationView: AnimationView?
        
        override func viewDidLoad() {
            super.viewDidLoad()

            //setupUI()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            animationView?.play()
        }
        
        private func setupUI() {
            guard let animationFileName = SwiftyCore.UI.LoadingViewController.animationFileName else {
                fatalError("Should configure loading lotie animation file name")
            }
            animationView = LoadingViewController.createAnimatioView(with: animationFileName)
            animationView?.loopMode = .loop
            animationView?.animationSpeed = 1.5
            addAnimationView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }

        private func addAnimationView() {
            if let animationView = animationView {
                animationViewPlaceholder?.addSubview(animationView)
                setAnimationViewConstraints()
            }
        }

        private func setAnimationViewConstraints() {
            animationView?.translatesAutoresizingMaskIntoConstraints = false
            animationView?.topAnchor.constraint(equalTo: animationViewPlaceholder.layoutMarginsGuide.topAnchor).isActive = true
            animationView?.leadingAnchor.constraint(equalTo: animationViewPlaceholder.leadingAnchor).isActive = true

            animationView?.bottomAnchor.constraint(equalTo: animationViewPlaceholder.layoutMarginsGuide.bottomAnchor).isActive = true
            animationView?.trailingAnchor.constraint(equalTo: animationViewPlaceholder.trailingAnchor).isActive = true
            animationView?.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        }

        private func showFinishAnimation(completion: @escaping () -> ()) {
            guard let animationFileName = Core.UI.LoadingViewController.finishAnimationFileName else {
                fatalError("Should configure finish lotie animation file name")
            }
            animationView?.removeFromSuperview()
            animationView = LoadingViewController.createAnimatioView(with: animationFileName)
            animationView?.loopMode = .playOnce
            animationView?.animationSpeed = 2.5
            addAnimationView()
            animationView?.play(completion: { success in
                completion()
            })
        }
        
        func dismissLoading(with success: Bool, completion: @escaping () -> ()) {
            if success {
                showFinishAnimation {
                    self.dismiss(animated: false, completion: completion)
                }
            } else {
                self.dismiss(animated: false, completion: completion)
            }
        }
        
        public static func createAnimatioView(with animation: String) -> AnimationView? {
            let animationName = animation.components(separatedBy: ".")[0]
            let animationLotieView = AnimationView()
            guard let path = Bundle.main.path(forResource: animationName, ofType: "json") else { return nil }
            let animation = Animation.filepath(path)
            animationLotieView.animation = animation
            animationLotieView.contentMode = .scaleAspectFit
            return animationLotieView
        }
    }
}
