//
//  Extension+UIImageView.swift
//  Simple Contact
//
//  Created by Ari Gonta on 24/04/20.
//  Copyright © 2020 Ari Gonta. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
}
