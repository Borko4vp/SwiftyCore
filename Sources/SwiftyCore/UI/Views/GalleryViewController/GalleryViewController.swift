//
//  GalleryViewController.swift
//  iVault
//
//  Created by Borko Tomic on 7.4.21..
//

import UIKit

public class GalleryViewController: UIViewController {

    //@IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    public var backgroundColor: UIColor = .black
    public var tintColor: UIColor = .white
    public var placeholderImage = UIImage(named: "galleryPlaceholder")
    public var images: [String] = []
    public var zoomEnabled = false
    
    private var selectedImageIndex = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        setupGestures()
        //setCurrentImage()
    }
    @IBAction private func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUi() {
        pageControl.numberOfPages = images.count
        titleLabel.text = ""
        backButton.setImage(UIImage(named: "backArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = tintColor
        view.backgroundColor = backgroundColor
        pageControl.isHidden = images.count < 2
        addScrollView()
    }
    
    private func addScrollView() {
        let carousel = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        carousel.showsHorizontalScrollIndicator = false
        carousel.contentInsetAdjustmentBehavior = .never
        carousel.isPagingEnabled = true
        let imagesLocal = images.isEmpty ? [""] : images
        for i in 0..<imagesLocal.count {
            let offset = i == 0 ? 0 : (CGFloat(i) * UIScreen.main.bounds.width)
            let imgView = UIImageView(frame: CGRect(x: offset, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            imgView.setRemoteImage(from: imagesLocal[i], placeholderImage: placeholderImage)
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFit
            imgView.tintColor = .white
            carousel.addSubview(imgView)

            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(_:)))
            imgView.isUserInteractionEnabled = true
            imgView.addGestureRecognizer(pinch)
        }
        carousel.contentSize = CGSize(width: CGFloat(imagesLocal.count) * UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        carousel.delegate = self
        self.view.insertSubview(carousel, at: 0)
    }
    
    @objc
    private func pinchHandler(_ sender: UIPinchGestureRecognizer) {
        guard zoomEnabled else { return }
        guard let targetView = sender.view else { return }
        targetView.transform = targetView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: {
                targetView.transform = CGAffineTransform.identity
            })
        }
    }
    
    
//    private func setCurrentImage() {
//        guard images.count > selectedImageIndex else {
//            mainImageView.image = galleryPlaceholderImage
//            return
//        }
//
//        UIView.transition(with: mainImageView,
//                          duration: 0.75,
//                          options: .curveEaseInOut,
//                          animations: { self.setImage() },
//                          completion: nil)
//        //mainImageView.setRemoteImage(from: images[selectedImageIndex], placeholderImage: galleryPlaceholderImage)
//        pageControl.currentPage = selectedImageIndex
//    }
//
//    private func setImage() {
//        mainImageView.setRemoteImage(from: images[selectedImageIndex], placeholderImage: galleryPlaceholderImage)
//    }

    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goNext))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goPrev))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc
    private func goNext() {
        guard selectedImageIndex < images.count-1 else { return }
        selectedImageIndex += 1
        //setCurrentImage()
    }
    
    @objc
    private func goPrev() {
        guard selectedImageIndex > 0 else { return }
        selectedImageIndex -= 1
        //setCurrentImage()
    }
}

extension GalleryViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pageControl.currentPage = Int(ceil(x/w))
    }
}
