//
//  BaseViewController.swift
//  CommonCore
//
//  Created by Borko Tomic on 21/11/2020.
//

import Foundation
import UIKit

extension SwiftyCore.UI {
    open class BaseViewController: UIViewController, LoadingController, KeyboardPresentable, BaseController, Toastaable {
        
        open var interactivePopGestureRecognizerEnabled: Bool {
            return true
        }
        
        var loadingViewController: LoadingViewController?
        
        
        open override func viewDidLoad() {
            super.viewDidLoad()
            
        }
        
        open override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            toggleKeyboardEvents(true)
        }
        
        open override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            navigationController?.interactivePopGestureRecognizer?.isEnabled = interactivePopGestureRecognizerEnabled
        }
        
        open override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            toggleKeyboardEvents(false)
        }
        
//        func pushViaMain(controller: BaseController) {
//            if let mainParent = parent as? MainViewController {
//                mainParent.push(controller: controller)
//            }
//        }
        
        public func toggleKeyboardEvents(_ on: Bool) {
            on ? KeyboardPresenter.shared.add(presenter: self) : KeyboardPresenter.shared.remove(presenter: self)
        }
        
        public func showLoading() {
            loadingViewController = LoadingViewController()
            //loadingViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            loadingViewController?.modalPresentationStyle = .overCurrentContext
            guard let loadingViewController = loadingViewController else { return }
            DispatchQueue.main.async {
                self.present(loadingViewController, animated: false, completion: nil)
            }
        }

        public func hideLoading(showSuccess: Bool = false, completion: (() -> Void)? = nil) {
            DispatchQueue.main.async {
                self.loadingViewController?.dismissLoading(with: showSuccess) {
                   self.loadingViewController = nil
                   completion?()
               }
            }
        }
        
        open func keyboardAboutToShow(keyboardSize: CGRect, duration: CGFloat?, curve: UIView.AnimationCurve?) {
            // override in each view controller
        }
        
        open func keyboardAboutToHide(keyboardSize: CGRect, duration: CGFloat?, curve: UIView.AnimationCurve?) {
            // override in each view controller
        }
        
        // This should be used inside keyboard events related methods for animation with keyboard
        // USE INSIDE: keyboardAboutToShow, keyboardAboutToHide
        open func animateWithKeyboard(duration: CGFloat?, curve: UIView.AnimationCurve?, block: @escaping () -> Void) {
            if let curve = curve, let duration = duration, duration > 0 {
                let animator = UIViewPropertyAnimator(duration: TimeInterval(duration), curve: curve, animations: block)
                animator.startAnimation()
            }
        }
    }
}

extension SwiftyCore.UI.BaseViewController: Alertable {
    open func didPressOk(on tag: String) {
        // should be overriden
    }
}
