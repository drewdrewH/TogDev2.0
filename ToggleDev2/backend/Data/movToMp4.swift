//
//  movToMp4.swift
//  ToggleDev2
//
//  Created by James McDougall on 12/30/20.
//

import Foundation
import AVKit

// Don't forget to import AVKit
func movToMp4(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?)  {
    let avAsset = AVURLAsset(url: videoURL, options: nil)
        
    let startDate = Date()
        
    //Create Export session
    guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
        completionHandler?(nil, nil)
        return
    }
        
    //Creating temp path to save the converted video
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    let mp4Basename: String = videoURL.deletingPathExtension().lastPathComponent + ".mp4"
    let filePath = documentsDirectory.appendingPathComponent(mp4Basename)
        
    //Check if the file already exists then remove the previous file
    if FileManager.default.fileExists(atPath: filePath.path) {
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {
            completionHandler?(nil, error)
        }
    }
        
    exportSession.outputURL = filePath
    exportSession.outputFileType = AVFileType.mp4
    exportSession.shouldOptimizeForNetworkUse = true
    let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
    let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
    exportSession.timeRange = range
        
    exportSession.exportAsynchronously(completionHandler: {() -> Void in
        switch exportSession.status {
        case .failed:
            print(exportSession.error ?? "NO ERROR")
            completionHandler?(nil, exportSession.error)
        case .cancelled:
            print("Export to mp4 canceled")
            completionHandler?(nil, nil)
        case .completed:
            //Video conversion finished
            let endDate = Date()
                
            _ = endDate.timeIntervalSince(startDate)
            //print(time)
            print("Successful conversion from mov to mp4!")
            print(exportSession.outputURL ?? "NO OUTPUT URL")
            completionHandler?(exportSession.outputURL, nil)
                
            default: break
        }
            
    })
}
