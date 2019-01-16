

import UIKit
import RealmSwift
import Realm

let screenSize = UIScreen.main.bounds.size

class CollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var collectionLayout: UICollectionViewFlowLayout!
    var realm: Realm!
    var realmResults: Results<ImageStore>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation
        self.navigationItem.title = "Images"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.tapAdd))
        // UICollectionFlowLayout
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.scrollDirection = .vertical
        // UICollectionView
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        collectionView.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        
        // Realm
        realm = try! Realm()
        realmResults = realm.objects(ImageStore.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(realmResults)
        collectionView.reloadData()
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let jpgData = realmResults[indexPath.row].image
        let image = UIImage(data: jpgData)!
        let identifier = realmResults[indexPath.row].identifier
        let imageEditingVC = ImageEditingViewController(image: image, identifier: identifier)
        self.navigationController?.pushViewController(imageEditingVC, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realmResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        let imageView = UIImageView(frame: cell.contentView.frame)
        imageView.backgroundColor = UIColor.black
        let jpgData = realmResults[indexPath.row].image
        imageView.image = UIImage(data: jpgData)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        cell.contentView.addSubview(imageView)
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: screenSize.width / 2.0, height: screenSize.width / 2.0)
        return size
    }
}

extension CollectionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    /*
     フォトライブラリを使うときは
     Privacy – Photo Library Usage Description（NSPhotoLibraryUsageDescription）
     
     カメラを使うときは
     Privacy – Camera Usage Description（NSCameraUsageDescription）
     
     を追加して利用目的を書きます
     これを入れないでフォトライブリやカメラを起動しようとするとアプリがストンと落ちます
     */
    
    @objc func tapAdd () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        try! realm.write {
            let imageData = image.jpegData(compressionQuality: 0.8)!
            let imageStore = ImageStore(value: ["image": imageData])
            realm.add(imageStore)
        }
        dismiss(animated: true, completion: nil)
        
        collectionView.reloadData()
    }
    
    
}


