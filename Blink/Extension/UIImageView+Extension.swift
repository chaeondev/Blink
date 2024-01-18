//
//  UIImageView+Extension.swift
//  Blink
//
//  Created by Chaewon on 1/18/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setKFImage(imageUrl: String) {
        let modifier = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(KeyChainManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            requestBody.setValue(APIKey.sesacKey, forHTTPHeaderField: "SesacKey")
            return requestBody
        }
        
        let url = URL(string: APIKey.baseURL + "/v1" + imageUrl)
        
        self.kf.setImage(with: url, placeholder: UIImage(resource: .dummy), options: [.requestModifier(modifier)])
    }
}
