//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/09/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    enum UserProfileSavingOption {
        case GCD
        case operationQueue
    }
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var userInfoTextView: UITextView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var selectProfilePhotoButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var saveButtons: [UIButton]!
    
    var model: IProfileModel!
    var currentProfile = ProfileViewModel.createDefaultProfile() {
        didSet {
            model.update(with: currentProfile)
            enableSaveButtons(model.profileWasModified)
        }
    }
    
    private var activeField: (UITextInput & UIView)?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
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
        saveUserProfile(using: .GCD)
    }
    
    @IBAction private func operationButtonAction(_ sender: UIButton) {
        saveUserProfile(using: .operationQueue)
    }
    
    @IBAction private func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - API
    
    func setDependencies(_ model: IProfileModel) {
        self.model = model
    }
    
    // MARK: - Private methods
    
    private func assertDependencies() {
        assert(model != nil)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func updateUI(with profile: ProfileViewModel) {
        nameTextField.text = profile.name
        userInfoTextView.text = profile.userInfo
        profileImageView.image = profile.profileImage
    }
    
    private func enableSaveButtons(_ flag: Bool) {
        saveButtons.forEach { $0.isEnabled = flag }
    }
    
    private func loadUserProfile() {
        activityIndicator.startAnimating()
        model.loadProfile { [unowned self] (loadedProfile, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.handleDataOperationError(error)
                    return
                }
                if let loadedProfile = loadedProfile {
                    self.currentProfile = loadedProfile
                    self.updateUI(with: loadedProfile)
                } else {
                    self.updateUI(with: self.currentProfile)
                }
            }
        }
    }
    
    private func handleDataOperationError(_ error: Error) {
        print("\(error)")
    }
    
    private func saveUserProfile(using savingOption: UserProfileSavingOption) {
        activityIndicator.startAnimating()
        enableSaveButtons(false)
        switch savingOption {
        case .GCD:
            model.saveProfileWithGCD { [unowned self] (success, error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if let error = error {
                        self.handleDataOperationError(error)
                        return
                    }
                    success ? self.showAlertForSuccessProfileSave() : self.showAlertForFailedProfileSave(with: savingOption)
                    self.enableSaveButtons(true)
                }
            }
        case .operationQueue:
            model.saveProfileWithOperationQueue { [unowned self] (success, error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if let error = error {
                        self.handleDataOperationError(error)
                        return
                    }
                    success ? self.showAlertForSuccessProfileSave() : self.showAlertForFailedProfileSave(with: savingOption)
                    self.enableSaveButtons(true)
                }
            }
        }
    }
    
    private func showAlertForSuccessProfileSave() {
        let alertController = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertForFailedProfileSave(with savingOption: UserProfileSavingOption) {
        let alertController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            self.saveUserProfile(using: savingOption)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        }
        profileImageView.image = image
        currentProfile = currentProfile.createCopyWithChanged(profileImage: image)
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
            currentProfile = currentProfile.createCopyWithChanged(name: text)
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
            currentProfile = currentProfile.createCopyWithChanged(userInfo: text)
        }
        activeField = nil
    }
}
