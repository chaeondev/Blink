//
//  UIButton+Extension.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit
import Kingfisher

extension UIButton {
    func setKFImage(imageUrl: String, placeholderImage: UIImage) {
        let modifier = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(KeyChainManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            requestBody.setValue(APIKey.sesacKey, forHTTPHeaderField: "SesacKey")
            return requestBody
        }
        
        let url = URL(string: APIKey.baseURL + "/v1" + imageUrl) ?? URL(string: "")
        
        let downloader = ImageDownloader.default
        
        downloader.downloadImage(with: url!, options: [.requestModifier(modifier)]) { result in
            switch result {
            case .success(let value):
                self.setImage(value.image, for: .normal)
            case .failure:
                print("===UIButton Kingfisher Image Download 실패===")
                self.setImage(placeholderImage, for: .normal)
            }
        }
    }
}
