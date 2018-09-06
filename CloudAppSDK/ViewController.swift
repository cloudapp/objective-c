//
//  ViewController.swift
//  CloudAppSDK
//
//  Created by Héctor Cuevas Morfín on 8/30/18.
//  Copyright © 2018 CloudApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CLAPIEngine.shared().delegate = self;

       // engine.getAccountToken("GetTokenAccount")
        
        //engine.getItemListStarting(atPage: 1, itemsPerPage: 5, userInfo: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    func itemListRetrievalSucceeded(_ items: [Any]!, connectionIdentifier: String!, userInfo: Any!) {
        for item in items {
            print(item)
        }
    }
    
    @IBAction func openLoginView() {
        CLAPIEngine.shared().logIn()
    }
    
    @IBAction func getDrops() {
        //CLAPIEngine.sharedInstance()?.getItemListStarting(atPage: 1, itemsPerPage: 10, userInfo: nil)
        CLAPIEngine.shared().getItemListStarting(atPage: 1, ofType: CLWebItemTypeVideo, itemsPerPage: 10, showOnlyItemsInTrash: false, userInfo: nil)
    }
    
}

extension ViewController: CLAPIEngineDelegate {
    func itemListRetrievalSucceeded(_ items: [CLWebItem]!, connectionIdentifier: String!, userInfo: Any!) {
        for item in items {
            print(item.name)
        }
    }
}

