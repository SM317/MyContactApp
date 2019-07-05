//
//  EditContactViewController.swift
//  MyContactApp
//
//  Created by SourabhMehta on 22/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit

class EditContactViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldMobileNumber: UITextField!
    @IBOutlet weak var textfieldLastName: UITextField!
    @IBOutlet weak var textfieldFirstName: UITextField!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var topViewPhoto: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var isFromAdd : Bool = false
    var editContact : Contact?
    var acticetextfield : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditContactViewController.handleTap_Target(sender:)))
        self.photoImage.addGestureRecognizer(tapGesture)
        
        
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolBar.barTintColor = UIColor.lightGray
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem.init(title: buttonDone, style: UIBarButtonItem.Style.plain, target: self, action: #selector(EditContactViewController.button_DoneMobileclicked(_:)))
        toolBar.setItems([flexSpace, doneButton], animated: true)
        self.textfieldMobileNumber.inputAccessoryView = toolBar
        
        if (!isFromAdd)
        {
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = Accessibility.Edit.DoneButton
            navigationItem.leftBarButtonItem?.accessibilityIdentifier = Accessibility.Edit.CancelButton
            self.refreshUI()
        }
        else{
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = Accessibility.Add.Done
            navigationItem.leftBarButtonItem?.accessibilityIdentifier = Accessibility.Add.Cancel
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshViewTopColor()
    }
    
    /**
     This method is used to refresh the UI after the api call
     */
    func refreshUI() {
        
        guard let contact = self.editContact else {
            return
        }
        self.textfieldFirstName.text = contact.firstName ?? ""
        self.textfieldLastName.text = contact.lastName ?? ""
        self.textfieldMobileNumber.text = contact.phoneNumber ?? ""
        self.textfieldEmail.text = contact.email ?? ""
        
        guard let profilePic = contact.profilePic else {
            photoImage.image = UIImage.init(named: Constants.Images.takePhoto)
            return
        }
        photoImage.downloaded(from: profilePic)
    }
    
    /* Update view_Top color with gradient */
    func refreshViewTopColor() {
        /* recolor navigation bar */
        self.topViewPhoto.layer.masksToBounds = true
        self.setVerticalGradientInView(self.topViewPhoto, color:Constants.Color.primaryLighterColor)
    }
    
    
    func updateContacts()
    {
        let contactId : Int = isFromAdd ? 0:   self.editContact?.id ?? 0
        
        let parameterDictionary : NSMutableDictionary = [Constants.ContactsKeys.firstName: self.textfieldFirstName.text ?? "",Constants.ContactsKeys.lastName: self.textfieldLastName.text ?? "",Constants.ContactsKeys.phoneNumber: self.textfieldMobileNumber.text ?? "",Constants.ContactsKeys.email: self.textfieldEmail.text ?? "",Constants.ContactsKeys.contactId: contactId]
        
        let dictMain : NSMutableDictionary = [:]
        
        self.showCustomLoader()
        DispatchQueue.main.async(execute: {
            if self.isFromAdd
            {
                parameterDictionary.setValue(true, forKey: Constants.ContactsKeys.favorite)
                parameterDictionary.setValue(Constants.getCurrentTime(), forKey: Constants.ContactsKeys.createdAt)
                parameterDictionary.setValue(Constants.getCurrentTime(), forKey: Constants.ContactsKeys.updatedAt)
                dictMain.setValue(parameterDictionary, forKey: DATA)
                EditContactProvider.createContact(withContactId: contactId, with: dictMain,withCompletion: { result in
                    guard case .success(_) = result else {
                        self.hideCustomLoader()
                        return
                    }
                    self.hideCustomLoader()
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else{
                parameterDictionary.setValue(Constants.getCurrentTime(), forKey: Constants.ContactsKeys.updatedAt)
                dictMain.setValue(parameterDictionary, forKey: DATA)
                EditContactProvider.updateContact(withContactId: contactId, with: dictMain,withCompletion: { result in
                    guard case .success(_) = result else {
                        self.hideCustomLoader()
                        return
                    }
                    self.hideCustomLoader()
                    self.dismiss(animated: true, completion: nil)
                })
            }
            
        })
    }
    
    @objc override func keyboardWillShow(_ notification: Notification) {
        var info = notification.userInfo!
        let kbSize: CGSize = ((info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size)!
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        if !aRect.contains(self.acticetextfield!.frame.origin) {
            self.scrollView.scrollRectToVisible(self.acticetextfield!.frame, animated: true)
        }
    }
    
    @objc override func keyboardWillHide(_ notification: Notification) {
        let contentInsets : UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK:UIImagePicker Delegates and Methods
    /**
     * These are the delegates of the text Field
     *
     */
    
    func openCamera()
    {
        if (UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: warning, message: cameraDoNotExist, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ok, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: warning, message:galleryPermisionDenied, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ok, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImaged = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.photoImage.roundedImage()
            self.photoImage.image = pickedImaged
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap_Target(sender : UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: chooseSourceType, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:camera, style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: gallery, style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonCancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonDoneClicked(_ sender: UIBarButtonItem) {
        
        if self.textfieldFirstName.text!.isEmpty {
            self.ShowError(errorFirstName)
        }
        else if self.textfieldLastName.text!.isEmpty {
            self.ShowError(errorLastName)
        }
        else if self.textfieldMobileNumber.text!.isEmpty {
            self.ShowError(errorMobileNumber)
        }
        else if self.textfieldEmail.text!.isEmpty{
            self.ShowError(errorEmail)
        }
        else if (Constants.isValidEmail(self.textfieldEmail.text!) == false)
        {
            self.ShowError(errorInvalidEmail)
        }
        else
        {
            self.updateContacts()
        }
    }
    
    @objc func button_DoneMobileclicked(_ sender: UIBarButtonItem)
    {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.textfieldMobileNumber.resignFirstResponder()
    }
}

//MARK:UITextFieldDelegate
/**
 * These are the delegates of the text Field
 *
 */

extension EditContactViewController : UITextFieldDelegate
{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        acticetextfield = textField
    }
    
     func textFieldDidEndEditing(_ textField: UITextField)
     {
        acticetextfield = nil
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var charCount:Int = 0
        
        if (range.length > 0)
        {
            // We're deleting
            charCount = (textField.text?.count)!-range.length
        }
        else
        {
            // We're adding
            charCount = (textField.text? .count)!+string.count
        }
        
        if textField == self.textfieldMobileNumber
        {
            if charCount > Constants.Length.phoneNumber
            {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if textField == self.textfieldFirstName {
            self.textfieldLastName.becomeFirstResponder()
        }
        else if textField == self.textfieldLastName
        {
            self.textfieldMobileNumber.becomeFirstResponder()
        }
        
        return true
    }
}

