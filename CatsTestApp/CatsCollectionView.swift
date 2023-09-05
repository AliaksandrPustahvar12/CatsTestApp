//
//  CatsCollectionView.swift
//  CatsTestApp
//
//  Created by Aliaksandr Pustahvar on 4.09.23.
//

import UIKit

class CatsCollectionView: UIViewController {
    
    let vm = CatsCollectionViewModel()
    private var  cats: [CatModel] = []
    
    private lazy var catsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        let itemSize: CGFloat = ((view.frame.size.width - 45) / 2)
        layout.itemSize = CGSize(width: itemSize, height: itemSize + 25)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        navigationItem.title = "Cats"
        setUpCollectionView()
        
        vm.updateCollection = { cats in
            self.cats = cats
            DispatchQueue.main.async {
                self.catsView.reloadData()
            }
        }
    }
    
    private func setUpCollectionView() {
        catsView.delegate = self
        catsView.dataSource = self
        catsView.register(CatsCollectionCell.self, forCellWithReuseIdentifier: "CatsCollectionCell")
        catsView.backgroundColor = .systemGray5
        catsView.showsVerticalScrollIndicator = false
        view.addSubview(catsView)
        
        catsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            catsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            catsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CatsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatsCollectionCell", for: indexPath) as! CatsCollectionCell
        cell.catName.text = cats[indexPath.row].name
        let cat = cats[indexPath.row]
        let id = cat.referenceImageId
        Task { @MainActor in
            if let imageData = await vm.getImageData(id: id) {
                cell.catImage.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedURL = URL(string: cats[indexPath.row].wikipediaUrl)
              
              let webViewController = WikiView()
              webViewController.url = selectedURL
              navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        let pos = scrollView.contentOffset.y
        print(pos, catsView.contentSize.height, scrollView.frame.size.height )
        if pos > catsView.contentSize.height + 70 - scrollView.frame.size.height && pos > 0 {
            guard !vm.isPagOn else { return }
            Task {
                await vm.getmoreCats()
            }
        }
    }
}
