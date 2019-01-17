//
//  ImageEditingViewController.swift
//  ImageFilterApp
//
//  Created by ryosuke kubo on 2019/01/11.
//  Copyright © 2019 ryosuke kubo. All rights reserved.
//

import UIKit
import CoreImage
import Realm
import RealmSwift

class ImageEditingViewController: UIViewController {

    var image: UIImage!
    let identifier: String
    var imageView: UIImageView!
    let filterNameArray: [String] = ["CIPhotoEffectMono", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CILinearToSRGBToneCurve"]
    var ciFilterTable: UITableView!
    let context = CIContext(options: nil)
    var realm: Realm!
    var result: Results<ImageStore>!
    
    init(image: UIImage, identifier: String) {
        self.image = image
        self.identifier = identifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // saveがタップされたら画像を上書き保存する
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
        let navigationBarSize = self.navigationController?.navigationBar.frame.height
        // self.navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        // 画像がタップされたら新しいフィルターに変更する
        imageView = UIImageView()
        imageView.bounds.size = CGSize(width: screenSize.width - 20, height: screenSize.width - 20)
        imageView.frame.origin = CGPoint(x: 10.0, y: navigationBarSize! + 10.0)
        self.navigationController?.hidesBarsOnTap = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedImage))
        // imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
        print(imageView.frame)
        
        // CoreImage TableView
        ciFilterTable = UITableView(frame: CGRect(x: 0, y: imageView.frame.height + 20, width: screenSize.width, height: screenSize.height - imageView.bounds.maxY), style: UITableView.Style.plain)
        ciFilterTable.backgroundColor = .black
        ciFilterTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ciFilterTable.delegate = self
        ciFilterTable.dataSource = self
        self.view.addSubview(ciFilterTable)
    }
    
    @objc func save () {
        realm = try! Realm()
        result = realm.objects(ImageStore.self)
        let alert = UIAlertController(title: "Save", message: nil, preferredStyle: UIAlertController.Style.alert)
        let saveNewImage = UIAlertAction(title: "新規保存", style: .default, handler: {(action) -> Void in
            print("New Image")
            let newImage = ImageStore(value: ["image": self.image.jpegData(compressionQuality: 0.9)])
            try! self.realm.write {
                self.realm.add(newImage)
                
            }
            self.navigationController?.popViewController(animated: true)
        })
        let saveOverride = UIAlertAction(title: "上書き保存", style: .default, handler: {(action) -> Void in
            print("Override Image")
            self.result = self.result.filter("identifier = %@", self.identifier)
            print(self.result)
            try! self.realm.write {
                let imageData = self.imageView.image?.jpegData(compressionQuality: 0.9)
                self.result[0].image = imageData!
            }
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(saveNewImage)
        alert.addAction(saveOverride)
        present(alert, animated: true, completion: {
            print("Show Alert")
        })
    }

    /*
    @objc func tappedImage () {
        print("start")

        let filter = CIFilter(name: filterNameArray[0])!
        filter.setDefaults()
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage!
        print("end editing")
        self.image = UIImage(ciImage: outputImage)
        DispatchQueue.main.async {
            self.imageView.image = self.image
            self.imageView.setNeedsLayout()
        }
        print(imageView.frame)
    }
    */


}

extension ImageEditingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルが選択されたときのコード
        print(indexPath.row)
        print("start")
        guard let coreImage = CIImage(image: self.image) else {
            print("coreImage is nil")
            return
        }
        guard let filter = CIFilter(name: filterNameArray[indexPath.row]) else {
            print("filer is nil")
            return
        }
        filter.setDefaults()
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        //let outputImage = filter.outputImage!
        let outputCGImage = context.createCGImage(filter.outputImage!, from: (filter.outputImage?.extent)!)
        print("end editing")
        self.image = UIImage(cgImage: outputCGImage!)
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        /*
        DispatchQueue.main.async {
            self.imageView.image = self.image
            self.imageView.setNeedsLayout()
        }
        */
        print(imageView.frame)
        print(image.size)
        print(type(of: image))
        print(image)
    }
}

extension ImageEditingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ciFilterTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filterNameArray[indexPath.row]
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 10
        return cell
    }
    
    
}

