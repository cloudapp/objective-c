//
//  ViewController.swift
//  CloudAppSDK
//
//  Created by Héctor Cuevas Morfín on 8/30/18.
//  Copyright © 2018 CloudApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CLAPIEngineDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // engine.getAccountToken("GetTokenAccount")
        
        //engine.getItemListStarting(atPage: 1, itemsPerPage: 5, userInfo: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CLAPIEngine.sharedInstance()?.signUp()

    }

    func itemListRetrievalSucceeded(_ items: [Any]!, connectionIdentifier: String!, userInfo: Any!) {
        for item in items {
            print(item)
        }
    }

}

