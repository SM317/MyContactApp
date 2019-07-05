//
//  ContactListViewController.swift
//  MyContactApp
//
//  Created by SourabhMehta on 21/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import UIKit

class ContactListViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactsListTableView: UITableView!
    
      // MARK: - Properties (Private)
    fileprivate var contactList: [Contact] = []
    fileprivate var contactListSearch: [Contact] = []
    fileprivate  var contactListSections: [ContactListSection] = []
   fileprivate  var selectedContactURL: String?
    fileprivate var isSearchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

         navigationItem.rightBarButtonItem?.accessibilityIdentifier = Accessibility.Root.AddButton
        
        self.title = appTitle
        // Do any additional setup after loading the view.
        
         self.contactsListTableView!.register(UINib.init(nibName: Constants.TableCustomCell.contact, bundle: nil), forCellReuseIdentifier: Constants.TableIdentifier.contactCell)
        
        self.searchBar.placeholder = contactPlaceholder
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getAllContacts()
    }

    /**
     This method is used to get all the contacts from the server
     */
    private func getAllContacts()
    {
        self.showCustomLoader()
        DispatchQueue.main.async(execute: {
            ContactProvider.contacts(withCompletion: { result in
                switch result {
                case .success(let allContact):
                    self.contactList = allContact
                    self.contactListSections = ContactProvider.getAllContactsWithIndex(contacts: allContact)
                    self.refreshUI()
                case .failure(_):
                    self.hideCustomLoader()
                    self.ShowError(errorContactList)
                }
            })
        })
    }
    
    /**
     This method is used to navigate to the detail controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.ControllerIdentifier.detailController, let destination = segue.destination as? ContactDetailViewController {
            destination.contactURL = selectedContactURL
        }
        else  if segue.identifier == Constants.ControllerIdentifier.editController, let destination = segue.destination as? EditContactViewController {
            destination.isFromAdd = true
        }
    }
    
    /**
     This method is used to refresh the UI after the api call
     */
    private func refreshUI() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            self?.hideCustomLoader()
            weakSelf.contactsListTableView.reloadData()
        }
    }
    
    /**
     This method is used to hide the keyboard
     */
    private func hideKeyboard()
    {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
      //MARK:- IBActions
    /**
     This method is used to navigate to the edit view controller
     */
    @IBAction func buttonAddClicked(_ sender: Any) {
        performSegue(withIdentifier: Constants.ControllerIdentifier.editController, sender: nil)
    }
}

extension ContactListViewController: UITableViewDelegate {
    // MARK: - UITableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = contactListSections[indexPath.section].contacts[indexPath.row]
        guard let selectedDetail = data.url else {
            return
        }
        selectedContactURL = selectedDetail
        self.searchBar.text = ""
        self.hideKeyboard()
        performSegue(withIdentifier: Constants.ControllerIdentifier.detailController, sender: nil)
    }
}


extension ContactListViewController: UITableViewDataSource {
     // MARK: - UITableview Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactListSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if contactListSections[section].contacts.count == 0 {
            return nil
        }
        return contactListSections[section].sectionTitle
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactListSections.compactMap({ $0.sectionTitle })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListSections[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let cell:ContactListCustomCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableIdentifier.contactCell, for: indexPath) as! ContactListCustomCell
        
        let contact = contactListSections[indexPath.section].contacts[indexPath.row]
        cell.contactNameLabel.text = contact.fullName
        cell.contactFavouriteImageView.isHidden = !(contact.favorite ?? false)
        cell.contactPhotoView.image = UIImage.init(named: Constants.Images.defaultPhotoImage)
        
        let imgseparator1 : UIImageView = UIImageView(frame: CGRect(x: 0, y: Constants.TableConstants.CELLHEIGHT - 1, width: self.view.frame.size.width, height: 1))
        imgseparator1.backgroundColor = Constants.Color.secondaryColor
        cell.addSubview(imgseparator1)
        
        guard let profilePic = contact.profilePic else {
            return cell
        }
        cell.contactPhotoView.downloaded(from: profilePic)
        return cell
    }
}


//MARK:- UISearchBarDelegate & UISearchResultsUpdating
extension ContactListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
        {
            if(contactListSearch.count > 0)
            {
                contactListSearch.removeAll()
            }
            contactListSearch = contactList.filter({( contact : Contact) -> Bool in
                    return  contact.fullName.lowercased().contains(searchText.lowercased())
            })
            if (contactListSearch.count > 0)
            {
                self.contactListSections.removeAll()
                self.contactListSections = ContactProvider.getAllContactsWithIndex(contacts: contactListSearch)
            }
            if searchText.count == 0
            {
               self.hideKeyboard()
                self.contactListSections.removeAll()
                self.contactListSections = ContactProvider.getAllContactsWithIndex(contacts: contactList)
            }
            contactsListTableView.reloadData()
        }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
         self.searchBar.showsCancelButton = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
       self.hideKeyboard()
        self.contactListSearch.removeAll()
        self.contactListSections.removeAll()
        self.contactListSections = ContactProvider.getAllContactsWithIndex(contacts: contactList)
        self.refreshUI()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.hideKeyboard()
    }
}
