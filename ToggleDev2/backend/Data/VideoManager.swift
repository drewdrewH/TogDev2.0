//
//  movToMp4.swift
//  ToggleDev2
//
//  Created by James McDougall on 12/30/20.
//

import Foundation
import AVKit

class VideoManager {
    
    // upload the video at specified user library url.
    func uploadVideo(url: URL, id: String) {
        do {
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let docDirURL: URL = documentsDirectoryURL.appendingPathComponent("\(id).mov")
            if FileManager.default.fileExists(atPath: docDirURL.path) {
                do {
                    try FileManager.default.removeItem(at: docDirURL)
                    print("Removed pre-existing file at \(docDirURL)")
                } catch {
                    print("Failed to remove file.")
                }
            }
            try FileManager.default.copyItem(at: url, to: docDirURL)
            //try FileManager.default.moveItem(at: url, to: docDirURL)
            print("Movie saved in application store.")
            let dataManager = DataManager()
            movToMp4(at: docDirURL) { (mp4Url, _) in
                dataManager.uploadFile(fileKey: mp4Url?.lastPathComponent ?? "test.mp4")
            }
        } catch {
            print(error)
        }
    }
    
    
    // Converts a url from .mov format to .mp4 format.
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
}

