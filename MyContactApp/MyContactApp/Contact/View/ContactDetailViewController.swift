//
//  ContactDetailViewController.swift
//  MyContactApp
//
//  Created by SourabhMehta on 22/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailViewController: BaseViewController {

    var contactURL: String?
    fileprivate var detailContact: Contact?
    @IBOutlet weak var contactPhotoView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var favouriteButtonImageView: UIImageView!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var buttonTopRight : UIButton? = nil
    var isContactFavourted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

         navigationItem.rightBarButtonItem?.accessibilityIdentifier = Accessibility.View.EditButton
        
        if self.buttonTopRight == nil {
            self.buttonTopRight = UIButton(type: UIButton.ButtonType.custom)
            self.buttonTopRight?.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
            self.buttonTopRight?.setTitle(buttonEdit, for: UIControl.State.normal)
            self.buttonTopRight?.setTitleColor(Constants.Color.primaryColor, for: UIControl.State.normal)
            self.buttonTopRight?.setTitleColor(Constants.Color.primaryColor.withAlphaComponent(0.3), for: UIControl.State.disabled)
            self.buttonTopRight?.backgroundColor = UIColor.clear
            self.buttonTopRight?.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right;
            self.buttonTopRight?.isEnabled = true
        }
        self.buttonTopRight?.addTarget(self, action: #selector(ContactDetailViewController.button_TopRight_Clicked(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.buttonTopRight!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContactDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshViewTopColor()
    }

    /**
     This method is used to fetch the contact detail from the server
     */
    func fetchContactDetails() {
        
        if let detailURL = self.contactURL
        {
            self.showCustomLoader()
            DispatchQueue.main.async(execute: {
                ContactDetailProvider.contactsDetails(withContactString: detailURL,withCompletion: { result in
                    switch result {
                    case .success(let details):
                        self.detailContact = details
                        self.hideCustomLoader()
                        self.refreshUI()
                    case .failure(_):
                        self.hideCustomLoader()
                        self.ShowError(errorContactDetail)
                    }
                })
            })
        }
    }
    
    /**
     This method is used to refresh the UI after the api call
     */
    func refreshUI() {
        
        contactName.text = self.detailContact?.fullName ?? ""
        
        isContactFavourted = self.detailContact?.favorite ?? false
        
        if isContactFavourted {
            favouriteButtonImageView.image = UIImage.init(named: Constants.Images.favoriteUnselected)
        } else {
            favouriteButtonImageView.image = UIImage.init(named: Constants.Images.favoriteSelected)
        }
        
        phoneNumberLabel.text = self.detailContact?.phoneNumber ?? ""
        emailLabel.text = self.detailContact?.email ?? ""
        
         self.contactPhotoView.roundedImage()
        guard let profilePic = self.detailContact?.profilePic else {
            contactPhotoView.image = UIImage.init(named: Constants.Images.defaultPhotoImage)
            return
        }
        contactPhotoView.downloaded(from: profilePic)
    }

    
    /* Update view_Top color with gradient */
    func refreshViewTopColor() {
        /* recolor navigation bar */
            self.topView.layer.masksToBounds = true
            self.setVerticalGradientInView(self.topView, color:Constants.Color.primaryLighterColor)
    }
    
    
    /**
     This method is used to send the SMS to the selected contact
     */
    func sendSMSText(phoneNumber: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = smsBody
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
     //MARK:- IBActions
    
    @objc func button_TopRight_Clicked (_ sender : AnyObject) {
          let storyBoard : UIStoryboard = AppDelegate.sharedInstance().get_StoryboardMain_Instance()
        let editController = storyBoard.instantiateViewController(withIdentifier: "viewEditController") as! EditContactViewController
        editController.editContact = self.detailContact
        self.navigationController?.present(editController, animated: true)
    }
    
    @IBAction func buttonFavClicked(_ sender: UIButton) {
        let isContactFavouretdInvert = !isContactFavourted
        guard let contactId = self.detailContact?.id else{
            return
        }
        
        let parameterDictionary : NSDictionary = [Constants.ContactsKeys.favorite: isContactFavouretdInvert,Constants.ContactsKeys.contactId: contactId]
        let dictMain : NSMutableDictionary = [:]
        dictMain.setValue(parameterDictionary, forKey: DATA)
        
        self.showCustomLoader()
        DispatchQueue.main.async(execute: {
            ContactDetailProvider.setFavoriteStatus(withContactId: contactId, with: dictMain,withCompletion: { result in
                switch result {
                case .success(_):
                    if isContactFavouretdInvert {
                        self.favouriteButtonImageView.image = UIImage.init(named: Constants.Images.favoriteUnselected)
                    } else {
                        self.favouriteButtonImageView.image = UIImage.init(named:Constants.Images.favoriteSelected)
                    }
                    self.fetchContactDetails()
                case .failure(_):
                    self.hideCustomLoader()
                    self.ShowError(errorFavorite)
                }
            })
        })
        
    }
    @IBAction func buttonEmailedClicked(_ sender: UIButton) {
        if let email = self.detailContact?.email
        {
            if MFMailComposeViewController.canSendMail() {
                let message:String  = emailMessage
                let composePicker = MFMailComposeViewController()
                composePicker.mailComposeDelegate = self
                composePicker.delegate = self
                composePicker.setToRecipients([email])
                composePicker.setSubject(emailSubject)
                composePicker.setMessageBody(message, isHTML: false)
                self.present(composePicker, animated: true, completion: nil)
            }
            else {
                self .ShowError(mailNotConfigure)
            }
        }
        
    }
    
    
    @IBAction func buttonCallClicked(_ sender: UIButton) {
        
        if let number = self.detailContact?.phoneNumber
        {
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    
    @IBAction func buttonMessageClicked(_ sender: UIButton) {
        if let number = self.detailContact?.phoneNumber
        {
            self.sendSMSText(phoneNumber: number)
        }
    }
    
    @IBAction func buttonDeleteClicked(_ sender: UIButton) {
    }

}


extension ContactDetailViewController : MFMessageComposeViewControllerDelegate
{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
}

extension ContactDetailViewController : MFMailComposeViewControllerDelegate,UINavigationControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                controller.dismiss(animated: true, completion: nil)
        }
}
