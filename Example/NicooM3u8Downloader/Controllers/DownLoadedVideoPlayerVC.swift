//
//  DownLoadedVideoPlayerVC.swift
//  NicooPlayer_Example
//
//  Created by 小星星 on 2018/7/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import NicooPlayer
import CocoaHTTPServer
import NicooM3u8Downloader
/// 播放本地视频
/// 模拟播放已下载好的本地视频

class DownLoadedVideoPlayerVC: UIViewController {
    
    private var server: HTTPServer! = nil
    private var port: UInt = 8080
    var videoName: String = ""
    
    /// 播放本地文件的时候，状态栏颜色样式与是否全屏无关 （默认全屏）
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let orirntation = UIApplication.shared.statusBarOrientation
        if  orirntation == UIInterfaceOrientation.landscapeLeft || orirntation == UIInterfaceOrientation.landscapeRight {
            return .lightContent
        }
        return .default
    }
   
    fileprivate lazy var videoPlayer: NicooPlayerView = {
        let player = NicooPlayerView(frame: self.view.frame, bothSidesTimelable: true)
        player.delegate = self
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playLocalVideo()
    }

    private func playLocalVideo() {
        server = HTTPServer()
        server.setType("_http.tcp")

    server.setDocumentRoot(NicooDownLoadHelper.getDocumentsDirectory().appendingPathComponent(NicooDownLoadHelper.downloadFile).appendingPathComponent(videoName).path)
        print("localFilePath = \(NicooDownLoadHelper.getDocumentsDirectory().appendingPathComponent(NicooDownLoadHelper.downloadFile).path)")
        server.setPort(UInt16(port))
        do {
            try server.start()
        }catch{
            print("本地服务器启动失败")
        }
        let videoLocalUrl = "\(getLocalServerBaseUrl()):\(port)/\(videoName).m3u8"
        videoPlayer.playLocalVideoInFullscreen(videoLocalUrl, "localFile", view)
        videoPlayer.playLocalFileVideoCloseCallBack = { [weak self] (playValue) in
            // 退出时，关闭本地服务器
            self?.server.stop()
            self?.navigationController?.popViewController(animated: false)
        }
    }
    
    private func getLocalServerBaseUrl() -> String {
        return "http://127.0.0.1"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

}

// MARK: - NicooPlayerDelegate

extension DownLoadedVideoPlayerVC: NicooPlayerDelegate {
    
    func retryToPlayVideo(_ player: NicooPlayerView, _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        
    }
    
    
    
    
}
