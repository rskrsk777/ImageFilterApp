

import UIKit

let screenSize = UIScreen.main.bounds.size

class CollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var collectionLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Images"
        
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    

}

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        let imageView = UIImageView(frame: cell.contentView.frame)
        imageView.backgroundColor = .gray
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
