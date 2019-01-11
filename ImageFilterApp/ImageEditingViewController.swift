//
//  ImageEditingViewController.swift
//  ImageFilterApp
//
//  Created by ryosuke kubo on 2019/01/11.
//  Copyright © 2019 ryosuke kubo. All rights reserved.
//

import UIKit

class ImageEditingViewController: UIViewController {

    var image: UIImage!
    var imageView: UIImageView!
    var filterNameLabel: UILabel!
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
        imageView.bounds.size = CGSize(width: screenSize.width, height: screenSize.width)
        imageView.center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = image
        view.addSubview(imageView)
        
        filterNameLabel = UILabel(frame: CGRect(x: 0.0, y: screenSize.height - ((screenSize.height - imageView.frame.maxY) / 2), width: screenSize.width, height: 30))
        filterNameLabel.text = "Filter"
        filterNameLabel.font = UIFont.systemFont(ofSize: 30)
        filterNameLabel.adjustsFontSizeToFitWidth = true
        filterNameLabel.textAlignment = NSTextAlignment.center
        filterNameLabel.layer.borderWidth = 3.0
        filterNameLabel.layer.borderColor = UIColor.black.cgColor
        print(filterNameLabel.font)
        view.addSubview(filterNameLabel)
    }


}
