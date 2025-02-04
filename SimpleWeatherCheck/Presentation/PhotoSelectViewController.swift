//
//  PhotoSelectViewController.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/4/25.
//

import UIKit
import PhotosUI

final class PhotoSelectViewController: BaseViewController {
    let photoSelectView = PhotoSelectView()
    var photoList = Observable([UIImage]())
    var completion: ((UIImage) -> ())?
    
    override func loadView() {
        view = photoSelectView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            UserDefaultsManager.shared.storedPhotos.images.forEach {
                self.photoList.value.append(UIImage(data: $0)!)
            }
        }
    }
    
    override func configView() {
        photoList.bind { _ in
            self.photoSelectView.collectionView.reloadData()
        }
    }
    
    override func configDelegate() {
        photoSelectView.collectionView.delegate = self
        photoSelectView.collectionView.dataSource = self
    }
    
    override func configNavigation() {
        navigationItem.title = "배경 선택"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "plus"),
            primaryAction: UIAction(handler: { _ in
                self.presentPHPhotoPicker()
            }))
    }
    
    func presentPHPhotoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.screenshots, .images])
        config.selectionLimit = 10
        config.mode = .default
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

extension PhotoSelectViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach {
            if $0.itemProvider.canLoadObject(ofClass: UIImage.self) {
                $0.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        self.photoList.value.append(image as! UIImage)
                    }
                }
            }
        }
        dismiss(animated: true) {
            var newValue = StoredPhoto(images: [])
            self.photoList.value.forEach {
                print(#function, $0)
                newValue.images.append($0.pngData() ?? Data())
            }
            UserDefaultsManager.shared.storedPhotos = newValue
        }
    }
}

extension PhotoSelectViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = photoList.value[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSelectCollectionViewCell.id, for: indexPath) as! PhotoSelectCollectionViewCell
        cell.config(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completion?(self.photoList.value[indexPath.item])
        print(#function, self.photoList.value[indexPath.item])
        navigationController?.popViewController(animated: true)
    }
}
