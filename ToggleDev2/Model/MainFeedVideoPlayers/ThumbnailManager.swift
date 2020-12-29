//
//  VideoThumbnail.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/26/20.
//

import Foundation
import UIKit
import AVKit
class ThumbnailManager {
    
    func previewImageFromVideo(url: NSURL) -> UIImage? {
        let url = url as URL
        let request = URLRequest(url: url)
        let cache = URLCache.shared

        if
            let cachedResponse = cache.cachedResponse(for: request),
            let image = UIImage(data: cachedResponse.data)
        {
            return image
        }

        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        var time = asset.duration
        time.value = min(time.value, 2)

        var image: UIImage?

        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch { }

        if
            let image = image,
            let data = image.pngData(),
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        {
            let cachedResponse = CachedURLResponse(response: response, data: data)

            cache.storeCachedResponse(cachedResponse, for: request)
        }

        return image
    }
}
