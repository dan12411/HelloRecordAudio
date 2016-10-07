//
//  ViewController.swift
//  HelloRecordAudio
//
//  Created by 洪德晟 on 2016/10/6.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

/// 1. 匯入函式庫
import AVFoundation

/// 18. 服從AVAudioRecorderDelegate，知道錄完要做什麼
class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    /// 1. 產生AVAudioRecorder
    var audioRecorder: AVAudioRecorder?
    /// 2. 紀錄是否在錄音
    var isRecording = false
    
    /// 22. 產生AVAudioPlayer
    var audioPlayer: AVAudioPlayer?
    
    /////////////////////
    /// Recodr Button ///
    /////////////////////
    @IBAction func myRecode(_ sender: UIButton) {
        
        /// 9. 判斷是否正在在錄音
        if isRecording == false {
            
            /// 7. 準備錄音
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
            /// 8. 錄出來的聲音會比較大聲！(老師密技：調整session狀態)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch {
                print("Can't set audio session")
            }
            
            /// 13. 跳出警告控制器
            let myAlert = UIAlertController(title: "Recording", message: "Press OK to stop", preferredStyle: .alert)
            
            /// 14. 產生OK Button
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                
                /// 15. 按下按鈕會停止錄音
                /// 10. 停止錄音
                self.audioRecorder?.stop()
                
                /// 11. 狀態回復成沒有在錄音
                self.isRecording = false
                
                /// 12. 調整session狀態為Playback & setActive為false
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                } catch {
                    print("Can't set audio session")
                }
                do {
                    try AVAudioSession.sharedInstance().setActive(false)
                } catch {
                    print("Can't set audio session")
                }
            })
            
            /// 16. 把ok按鈕加到警告控制器
            myAlert.addAction(okAction)
            
            /// 17. 顯示警告控制器
            present(myAlert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 3. 找到存檔的路徑
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        /// 4. 要存檔的檔名及位置
        let filePath = dirPath + "/user.wav"
        
        /// 亦可得到3.~4.一樣的路
        let filePath2 = NSHomeDirectory() + "/Documents/user.wav"
        
        /// 產生url路徑
        let url = URL(fileURLWithPath: filePath2)
        
        /// 5. 設定一下錄音相關的數據
        let recordSettings: [String:Any] = [
            AVEncoderAudioQualityKey : AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey : 16,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.0
        ]
        
        /// 6. 產生AVAudioRecorder
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recordSettings)
            /// 19. 連結到自己
            audioRecorder?.delegate = self
        } catch {
            print(" 🚫 Something Wrong! 🚫 ")
        }
    }
    
    /// 20. 錄完要做的事
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            
            /// 21. 如果錄成功的話，就用錄好的音檔做出一個AVAudioPlayer，來播放錄音的結果
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
            } catch {
                print(" 🚫 Something Wrong! 🚫 ")
            }
        }
    }
    
    ///////////////////
    /// Play Button ///
    ///////////////////
    /// 23. 按下按鈕，播放錄音檔
    @IBAction func myPlay(_ sender: UIButton) {
        
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

