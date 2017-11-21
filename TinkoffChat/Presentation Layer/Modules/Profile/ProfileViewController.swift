//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/09/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var userInfoTextView: UITextView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var selectProfilePhotoButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var saveButton: UIButton!
    
    private enum SegueIdentifiers: String {
        case segueToProfileImagePickerViewControllerIdentifier
        case unwindSegueToConversationsList
    }
    
    var rootAssembly: IRootAssembly!
    var model: IProfileModel!
    
    var currentProfile: ProfileViewModel? {
        didSet {
            if let currentProfile = currentProfile {
                model.update(with: currentProfile)
                enableSaveButton(model.profileWasModified)
            }
        }
    }
    
    private var activeField: (UITextInput & UIView)?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        enableSaveButton(false)
        loadUserProfile()
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = selectProfilePhotoButton.layer.cornerRadius
    }
    
    // MARK: - Actions
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        saveUserProfile()
    }
    
    @IBAction private func selectProfilePhotoAction(_ sender: UIButton) {
        print("Выбери изображение профиля")
        showAlertForChangingProfilePhoto()
    }
    
    @IBAction private func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - API
    
    func setDependencies(_ model: IProfileModel) {
        self.model = model
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.segueToProfileImagePickerViewControllerIdentifier.rawValue?:
            guard let containerViewController = segue.destination as? UINavigationController,
                let profileImagePickerViewController = containerViewController.topViewController as? ProfileImagePickerViewController else {
                    assertionFailure("Unknown segue destination")
                    return
            }
            rootAssembly.profileImagePickerAssembly.assembly(profileImagePickerViewController)
            profileImagePickerViewController.onSelectProfileImage = { [weak self] selectedImage in
                self?.updateUserProfile(with: selectedImage)
            }
        case SegueIdentifiers.unwindSegueToConversationsList.rawValue?:
            break
        default:
            assertionFailure("Unknown segue")
            return
        }
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
    
    private func enableSaveButton(_ flag: Bool) {
        saveButton.isEnabled = flag
    }
    
    private func loadUserProfile() {
        activityIndicator.startAnimating()
        model.loadProfile { loadedProfile in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.currentProfile = loadedProfile
                self.updateUI(with: loadedProfile)
            }
        }
    }
    
    private func saveUserProfile() {
        activityIndicator.startAnimating()
        enableSaveButton(false)
        model.saveProfile {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.showAlertForSuccessProfileSave()
            }
        }
    }
    
    private func updateUserProfile(with image: UIImage?) {
        profileImageView.image = image
        currentProfile = currentProfile?.createCopyWithChanged(profileImage: image)
    }
    
    private func showAlertForSuccessProfileSave() {
        let alertController = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
        let loadFromInternetAction = UIAlertAction(title: "Загрузить из сети", style: .default) { _ in
            self.performSegue(withIdentifier: SegueIdentifiers.segueToProfileImagePickerViewControllerIdentifier.rawValue, sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(loadFromInternetAction)
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
        updateUserProfile(with: image)
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
            currentProfile = currentProfile?.createCopyWithChanged(name: text)
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
            currentProfile = currentProfile?.createCopyWithChanged(userInfo: text)
        }
        activeField = nil
    }
}
