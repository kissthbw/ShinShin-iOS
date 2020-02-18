//
//  ResourceViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 05/02/20.
//  Copyright © 2020 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import WebKit

class ResourceViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let url = Bundle.main.url(forResource: "aviso_privacidad", withExtension: "docx", subdirectory: "Resources")!
        if let url = Bundle.main.url(forResource: "aviso_privacidad", withExtension: "docx") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
//            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
