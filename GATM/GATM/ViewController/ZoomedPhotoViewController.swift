//
//  ZoomedPhotoViewController.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 12/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class ZoomedPhotoViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = photo?.size.width ?? 0.0
        let height = photo?.size.height ?? 0.0
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView.image = photo
        
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        // maximumZoomScale defaults to 1
    }
}

extension ZoomedPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
      updateConstraintsForSize(view.bounds.size)
    }
    
    func updateConstraintsForSize(_ size: CGSize) {
      let yOffSet = max(0, (size.height - imageView.frame.height) / 2)
      let xOffSet = max(0, (size.width - imageView.frame.width) / 2)
      imageViewTopConstraint.constant = yOffSet
      imageViewBottomConstraint.constant = yOffSet
      imageViewLeadingConstraint.constant = xOffSet
      imageViewTrailingConstraint.constant = xOffSet
      view.layoutIfNeeded()
    }
}
