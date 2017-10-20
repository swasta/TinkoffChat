//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/09/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userInfoTextView: UITextView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var selectProfilePhotoButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var saveButtons: [UIButton]!
    
    private var activeField: (UITextInput & UIView)?
    
    private var originalProfile = UserProfile.createDefaultProfile()
    private var modifiedProfile = UserProfile.createDefaultProfile() {
        didSet {
            let shouldEnableSaveButtons = modifiedProfile != originalProfile
            enableSaveButtons(shouldEnableSaveButtons)
            updateUI()
        }
    }
    
    private let gcdDataManager = GCDDataManager()
    private let operationDataManager = OperationDataManager()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableSaveButtons(false)
        loadUserProfile()
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = selectProfilePhotoButton.layer.cornerRadius
    }
    
    // MARK: - Actions
    
    @IBAction private func selectProfilePhotoAction(_ sender: UIButton) {
        print("Выбери изображение профиля")
        showAlertForChangingProfilePhoto()
    }
    
    @IBAction private func gcdButtonAction(_ sender: UIButton) {
        saveUserProfile(using: gcdDataManager)
    }
    
    @IBAction private func operationButtonAction(_ sender: UIButton) {
        saveUserProfile(using: operationDataManager)
    }
    
    @IBAction private func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Private methods
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func updateUI() {
        nameTextField.text = modifiedProfile.name
        userInfoTextView.text = modifiedProfile.userInfo
        profileImageView.image = modifiedProfile.profileImage
    }
    
    private func enableSaveButtons(_ flag: Bool) {
        saveButtons.forEach { $0.isEnabled = flag }
    }
    
    private func loadUserProfile() {
        activityIndicator.startAnimating()
        let profileDataManager = getRandomProfileDataManager() // randomly read with GCD or Operation
        profileDataManager.loadUserProfile { [unowned self] profile, error in
            self.activityIndicator.stopAnimating()
            if let loadedProfile = profile {
                self.originalProfile = loadedProfile
                self.modifiedProfile = loadedProfile
            } else {
                self.updateUI()
            }
            if error != nil {
                self.handleDataOperationError(error!)
            }
        }
    }
    
    private func handleDataOperationError(_ error: Error) {
        print("\(error)")
    }
    
    private func getRandomProfileDataManager() -> ProfileDataManager {
        let managers: [ProfileDataManager] = [gcdDataManager, operationDataManager]
        return managers[Int(arc4random_uniform(UInt32(managers.count)))]
    }
    
    private func saveUserProfile(using dataManager: ProfileDataManager) {
        activityIndicator.startAnimating()
        enableSaveButtons(false)
        dataManager.save(modifiedProfile) { [unowned self] success, error in
            self.activityIndicator.stopAnimating()
            if success {
                self.showAlertForSuccessProfileSave()
                self.originalProfile = self.modifiedProfile
            } else {
                self.showAlertForFailedProfileSave(with: dataManager)
            }
            if error != nil {
                self.handleDataOperationError(error!)
            }
        }
    }
    
    private func showAlertForSuccessProfileSave() {
        let alertController = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertForFailedProfileSave(with dataManager: ProfileDataManager) {
        let alertController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { action in
            self.saveUserProfile(using: dataManager)
        })
        present(alertController, animated: true, completion: nil)
    }
    
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

extension ProfileViewController {
    @objc private func keyboardWasShown(_ notification: Notification) {
        guard let info = notification.userInfo else {
            return
        }
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let verticalSpacing = view.frame.height / 10
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + verticalSpacing, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var viewRect = view.frame
        viewRect.size.height -= keyboardSize.height
        if let activeField = self.activeField {
            let activeFieldFrame = activeField.convert(activeField.bounds, to: scrollView)
            let activeFieldBottomLeftPoint = CGPoint(x: activeFieldFrame.minX, y: activeFieldFrame.maxY)
            if !viewRect.contains(activeFieldBottomLeftPoint) {
                scrollView.scrollRectToVisible(activeFieldFrame, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        }
        modifiedProfile = modifiedProfile.createCopyWithChanged(profileImage: image)
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            modifiedProfile = modifiedProfile.createCopyWithChanged(name: text)
        }
        activeField = nil
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            modifiedProfile = modifiedProfile.createCopyWithChanged(userInfo: text)
        }
        activeField = nil
    }
}
