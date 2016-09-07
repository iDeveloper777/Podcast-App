//
//  PlayViewController.swift
//  IDEAS
//
//  Created by iDeveloper on 8/16/16.
//  Copyright © 2016 Cristi Irascu. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PlayViewcController: UIViewController {
    
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var btn_First: UIButton!
    @IBOutlet weak var btn_Speed: UIButton!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var xmlData :XMLData!
    var playMode = 0
    var speedMode = 0
    
//    var player: AVAudioPlayer!
    
    var player: AVPlayer!
    var playerItem: AVPlayerItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = xmlData.title
        let imageURL = NSURL(string:xmlData.image_url)
        imgThumb?.sd_setImageWithURL(imageURL, placeholderImage: nil)
        
        let soundURL = NSURL(string:xmlData.enclosure_url)
//        downloadFileFromURL(soundURL!)
        
        playerItem = AVPlayerItem(URL: soundURL!)
        player=AVPlayer(playerItem: playerItem!)
//        let playerLayer=AVPlayerLayer(player: player!)
//        playerLayer.frame=CGRectMake(0, 0, 300, 50)
//        self.view.layer.addSublayer(playerLayer)

    }
    
//    func downloadFileFromURL(url:NSURL){
//        var downloadTask:NSURLSessionDownloadTask
//        downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(url, completionHandler: { (URL, response, error) -> Void in
//            
//
//            self.play(URL!)
//            
//        })
//        
//        downloadTask.resume()
//        
//    }
//    
//    func play(url:NSURL) {
//        print("playing \(url)")
//        
//        do {
//            self.player = try AVAudioPlayer(contentsOfURL: url)
//            player.prepareToPlay()
//            player.volume = 1.0
//            player.play()
//        } catch let error as NSError {
//            //self.player = nil
//            print(error.localizedDescription)
//        } catch {
//            print("AVAudioPlayer init failed")
//        }
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func click_Back(sender: AnyObject) {
        player = nil
        playerItem = nil
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func click_First(sender: AnyObject) {
        player = nil
        playerItem = nil
        let soundURL = NSURL(string:xmlData.enclosure_url)
        playerItem = AVPlayerItem(URL: soundURL!)
        player=AVPlayer(playerItem: playerItem!)
        
        if player!.rate == 0 && playMode == 1{
            
            player!.play()
        }
    }
    
    @IBAction func click_Play(sender: AnyObject) {
        if playMode == 0{
            playMode = 1
            let image = UIImage(named: "btn_Pause.png") as UIImage?
            self.btn_Play.setBackgroundImage(image, forState: .Normal)
            
            if player!.rate == 0
            {
                player!.play()
                
                if self.speedMode == 0{
                    player!.rate = 1.0
                }else if self.speedMode == 1{
                    player!.rate = 2.0
                }else{
                    player!.rate = 0.5
                }
            }
        }else{
            playMode = 0
            let image = UIImage(named: "btn_Play.png") as UIImage?
            self.btn_Play.setBackgroundImage(image, forState: .Normal)
            
            if player!.rate != 0{
                self.player!.pause()
            }

        }
    }
    
    @IBAction func click_Speed(sender: AnyObject) {
        if speedMode == 0{
            speedMode = 1
            let image = UIImage(named: "btn_2x.png") as UIImage?
            self.btn_Speed.setBackgroundImage(image, forState: .Normal)
            
            player!.rate = 2.0
        }else if speedMode == 1{
            speedMode = 2
            let image = UIImage(named: "btn_12x.png") as UIImage?
            self.btn_Speed.setBackgroundImage(image, forState: .Normal)
            player!.rate = 0.5
        }else{
            speedMode = 0
            let image = UIImage(named: "btn_1x.png") as UIImage?
            self.btn_Speed.setBackgroundImage(image, forState: .Normal)
            
            player!.rate = 1
        }
    }
    
    
}