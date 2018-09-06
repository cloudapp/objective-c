//
//  ViewController.swift
//  CloudAppSDK
//
//  Created by Héctor Cuevas Morfín on 8/30/18.
//  Copyright © 2018 CloudApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CLAPIEngineDelegate {
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CLAPIEngine.shared().delegate = self
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // CLAPIEngine.sharedInstance()?.signUp()
        
    }
    @IBAction func login(_ sender: Any) {
        CLAPIEngine.shared().logIn()
    }
    @IBAction func getitems(_ sender: Any) {
        CLAPIEngine.shared().getItemListStarting(atPage: 1, itemsPerPage: 5, userInfo: nil)
    }
    
    @IBAction func getVideosTapped(_ sender: Any) {
        CLAPIEngine.shared().getItemListStarting(atPage: 1, ofType: CLWebItemTypeVideo, itemsPerPage: 10, showOnlyItemsInTrash: false, userInfo: nil)
    }
    
    
    
    func itemListRetrievalSucceeded(_ items: [CLWebItem]!, connectionIdentifier: String!, userInfo: Any!) {
        for item in items {
            print("name: ",item.name, "type", item.type)
        }
        print("\n")
    }
    
    
    @IBAction func showPicker(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    func fileUploadDidSucceed(withResultingItem item: CLWebItem!, connectionIdentifier: String!, userInfo: Any!) {
        print(item.url)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        
        CLAPIEngine.shared().uploadFile(withName: imageURL.lastPathComponent, atPathOnDisk: imageURL.path, options: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func fileUploadDidProgress(_ percentageComplete: CGFloat, connectionIdentifier: String!, userInfo: Any!) {
        // print(percentageComplete)
    }
    
}
