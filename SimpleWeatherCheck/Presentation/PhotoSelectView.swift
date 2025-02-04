//
//  PhotoSelectView.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/4/25.
//

import UIKit

import SnapKit
import Then

final class PhotoSelectView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func configHierarchy() {
        addSubview(collectionView)
    }
    
    override func configLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        collectionView.do {
            $0.register(PhotoSelectCollectionViewCell.self, forCellWithReuseIdentifier: PhotoSelectCollectionViewCell.id)
        }
    }
}

class PhotoSelectCollectionViewCell: UICollectionViewCell {
    
    static let id = "PhotoSelectCollectionViewCell"
    
    let imageViwe = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(imageViwe)
        imageViwe.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageViwe.contentMode = .scaleAspectFill
        imageViwe.clipsToBounds = true
    }
    
    func config(item: UIImage) {
        imageViwe.image = item
    }
    
}
