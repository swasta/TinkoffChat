//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/09/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var selectProfilePhotoButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // print(editButton.frame) в данный момент аутлеты еще не инициализированы, обращение к nil вызовет краш
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function) \(editButton.frame)") // фрейм editButton'а еще не является окончательным, autolayout еще не сработал
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function) \(editButton.frame)") // фрейм editButton'а все еще не является окончательным
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = selectProfilePhotoButton.layer.cornerRadius
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(#function) \(editButton.frame)") // здесь фрейм уже окончателен
    }
    
    // MARK: - Actions
    
    @IBAction func selectProfilePhotoAction(_ sender: UIButton) {
        print("Выбери изображение профиля")
        showAlertForChangingProfilePhoto()
    }
    
    // MARK: - Private methods
    
    private func showAlertForChangingProfilePhoto() {
        let alertController = UIAlertController(title: "Изменить изображение профиля", message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = selectProfilePhotoButton
        alertController.popoverPresentationController?.sourceRect = selectProfilePhotoButton.bounds
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.showImagePicker(for: .camera)
        }
        let photoLibraryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
            self.showImagePicker(for: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showImagePicker(for sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            let alertController = UIAlertController(title: "Ошибка", message: "Выбранный источник недоступен", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle = (sourceType == .camera) ? .fullScreen : .popover
        imagePickerController.popoverPresentationController?.sourceView = selectProfilePhotoButton
        imagePickerController.popoverPresentationController?.sourceRect = selectProfilePhotoButton.bounds
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        }
        profileImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
