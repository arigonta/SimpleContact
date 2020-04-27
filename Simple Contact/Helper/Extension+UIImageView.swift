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
    
    func convertImageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 0.5)?.base64EncodedString()
    }
}
