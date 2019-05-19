//
//  ViewController.swift
//  MemeMe 2.0
//
//  Created by MACBOOK on 12/22/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit
import Foundation


class memeCreatorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    var frameForCapture: CGRect!
    var currentKBHeight: CGFloat = 0.0
    var meme: Meme!
    
    @IBOutlet var toolBarTwo: UIToolbar!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var imagePicker: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var bottomTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable camera button if camera source isn't available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        func setupTextField(_ textField: UITextField) {
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .center
        }
        setupTextField(bottomTextField)
        setupTextField(topTextField)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func pictureFrom(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        shareButton.isEnabled = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            pictureFrom(sourceType: .camera)
        }
        
    }
    
    @IBAction func photoAlbum(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            pictureFrom(sourceType: .photoLibrary)
        }
        
    }
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -4.5
    ]
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder{
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder{
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topTextField: topTextField.text! as String, bottomTextField: bottomTextField.text! as String, originalImage: imagePickerView.image, memedImage: memedImage)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    
    func hideControls(_ hide: Bool) {
        toolBar.isHidden = hide
        toolBarTwo.isHidden = hide

    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        hideControls(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hideControls(false)
        
        return memedImage
    }
    @IBAction func shareImage(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if (success){
                self.save(memedImage: self.generateMemedImage())
            }
        }
        // Show UIActivityViewController
        present(activityViewController, animated: true, completion: nil)
        
        navigationController?.setToolbarHidden(false, animated: false)
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        imagePickerView.image = nil
        topTextField.text?.removeAll()
        bottomTextField.text?.removeAll()
        viewDidLoad()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

