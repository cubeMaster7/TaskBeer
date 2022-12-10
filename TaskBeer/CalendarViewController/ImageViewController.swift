//
//  ImageViewController.swift
//  TaskBeer
//
//  Created by Paul James on 10.12.2022.
//

import Foundation
import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageCard: CalendarModel?
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentMode = .scaleAspectFit
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = .black
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 6
        return sv
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
        loadImage()
        setupGesture()
    }
    

    func setupView() {
        view.backgroundColor = .black
        view.alpha = 1
        
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(closeButton)
    }
    
    func setupConstraint(){
        scrollView.frame = view.bounds
        imageView.frame = scrollView.bounds
        closeButton.frame = CGRect(x: view.frame.size.width - 40, y: 20, width: 25, height: 25)
    }
    
    func loadImage() {
        guard let data = imageCard?.imageData, let image = UIImage(data: data) else {return}
        imageView.image = image
    }
    
    @objc func closeButtonTapped() {
        let transistion = CATransition()
        transistion.duration = 0.3
        transistion.type = .reveal
        transistion.subtype = .fromBottom
        self.view.window?.layer.add(transistion, forKey: kCATransition)
        dismiss(animated: true)
    }

    
    func setupGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapOnScrollView(recognizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTapGesture)
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapOnScrollView(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
        
    }
    
    
    @objc func handleSingleTapOnScrollView(recognizer: UITapGestureRecognizer) {
        if closeButton.isHidden {
            closeButton.isHidden = false
        } else {
            closeButton.isHidden = true
        }
        
    }
    
    @objc func handleDoubleTapOnScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
            closeButton.isHidden = true
        } else {
            scrollView.setZoomScale(1, animated: true)
            closeButton.isHidden = false
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        
        let newCentr = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCentr.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCentr.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW:ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width): (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height): (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
}
