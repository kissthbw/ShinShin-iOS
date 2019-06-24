//
//  UIImageView+DownloadImage.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/21/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

extension UIImageView{
    func loadImage(url: URL) ->URLSessionDownloadTask{
        let session = URLSession.shared
        
        //1. URLSessionDownloadTask save in a temp file istead of in memory
        let downloadTask = session.downloadTask(with: url) {
            [weak self] url, response, error in
            
            //url: temp file
            if error == nil, let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data){
                
                DispatchQueue.main.async {
                    if let weakself = self{
                        weakself.image = image
                    }
                }
            }
        }
        
        downloadTask.resume()
        
        return downloadTask
    }
}

