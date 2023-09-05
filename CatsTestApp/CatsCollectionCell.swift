//
//  CatsCollectionCell.swift
//  CatsTestApp
//
//  Created by Aliaksandr Pustahvar on 4.09.23.
//

import UIKit

class CatsCollectionCell: UICollectionViewCell {
    
    let catImage = UIImageView()
    let catName = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCell()
        
        catImage.translatesAutoresizingMaskIntoConstraints = false
        catName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            catImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            catImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            catImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            catImage.heightAnchor.constraint(equalToConstant: (contentView.frame.width - 16)),
            
            catName.topAnchor.constraint(equalTo: catImage.bottomAnchor, constant: 5),
            catName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            catName.heightAnchor.constraint(equalToConstant: 20),
            catName.widthAnchor.constraint(equalToConstant: contentView.frame.width - 8)
        ])
    }
    
    private func setUpCell() {
        backgroundColor = .systemGray6
        
        catImage.frame = CGRect(origin: .zero , size: .init(width: contentView.frame.width - 8, height: contentView.frame.width - 8))
        catImage.contentMode = .scaleAspectFit
        catImage.clipsToBounds = true
        
        catName.textAlignment = .center
        catName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        catName.adjustsFontSizeToFitWidth = true
        catName.textColor = UIColor(named: "textLabelColor")
        
        contentView.addSubview(catImage)
        contentView.addSubview(catName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        catImage.image = nil
    }
}
