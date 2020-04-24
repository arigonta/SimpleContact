//
//  DetailContactViewController.swift
//  Simple Contact
//
//  Created by Ari Gonta on 24/04/20.
//  Copyright © 2020 Ari Gonta. All rights reserved.
//

import UIKit
import Kingfisher

class DetailContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    let imagePicker = UIImagePickerController()
    var imageBase64 = ""
    
    var contact: Contact?
    var HTTPMethod: HTTPMethod?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        Configure()
    }
    
    func Configure() {
        
        firstNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        lastNameNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        ageTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        profileImage.setRounded()
        
        if contact != nil {
            firstNameTextField.text = contact?.firstName
            lastNameNameTextField.text = contact?.lastName
            ageTextField.text = "\(contact?.age ?? 0)"
            
            if contact?.photo?.absoluteString.contains("http") ?? false {
                profileImage.kf.setImage(with: contact?.photo)
            } else {
                let newImageData = Data(base64Encoded: contact?.photo?.absoluteString ?? "")
                if let newImageData = newImageData {
                    profileImage.image = UIImage(data: newImageData)
                } else {
                    profileImage.image = #imageLiteral(resourceName: "profilePlaceHolder")
                }
            }
            
        } else {
            firstNameTextField.placeholder = "Input Your First Name"
            lastNameNameTextField.placeholder = "Input Your Last Name"
            ageTextField.placeholder = "Input Your Age"
            profileImage.image = #imageLiteral(resourceName: "profile")
        }
    }
    
    @IBAction func didTapImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (button) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = .camera
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        profileImage.image = pickedImage
        imageBase64 = profileImage.convertImageToBase64(pickedImage)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    private func insertData() -> Contact {
        let contact = Contact(id: nil,
                              firstName: firstNameTextField.text,
                              lastName: lastNameNameTextField.text,
                              age: Int(ageTextField.text ?? ""),
                              photo: URL(string: imageBase64))
        return contact
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        doneButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.HTTPMethod == .PUT {
                let contactRequest = APIManager(endpoint: "\(Constant.endpoint)/\(self.contact?.id ?? "")")
                contactRequest.sendRequest(self.insertData(), httpMethod: .PUT, completion: { result in
                    switch result {
                    case .failure(let err):
                        print(err)
                    case .success(let value):
                        print(value)
                    }
                })
            } else {
                let contactRequest = APIManager(endpoint: Constant.endpoint)
                contactRequest.sendRequest(self.insertData(), httpMethod: .POST, completion: { result in
                    switch result {
                    case .failure(let err):
                        print(err)
                    case .success(let value):
                        print(value)
                    }
                })
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
