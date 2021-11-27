//
//  VideoCell.swift
//  ACL
//
//  Created by Aman on 08/11/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCell: UITableViewCell {
    //MARK: outlets
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var starBtn: UIButton!
    
//    var playerController: ASVideoPlayerController?
//    var videoLayer: AVPlayerLayer = AVPlayerLayer()
//    var videoURL: String? {
//        didSet {
//            if let videoURL = videoURL {
//                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
//            }
//            videoLayer.isHidden = videoURL == nil
//        }
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//          backgroundColor = Colors.colorClear

          self.videoView.layer.borderWidth = 1
          self.videoView.layer.cornerRadius = 3
          self.videoView.layer.borderColor = UIColor.clear.cgColor
          self.videoView.layer.masksToBounds = true

          self.layer.shadowOpacity = 0.18
          self.layer.shadowOffset = CGSize(width: 0, height: 2)
          self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
          self.layer.masksToBounds = false
        selectionStyle = .none
    }

//     func configureCell(imageUrl: String?,
//                          description: String,
//                          videoUrl: String?) {
//           self.videoTitle.text = description
//           //self.shotImageView.imageURL = imageUrl
//           self.videoURL = videoUrl
//       }
//    override func prepareForReuse() {
//        //videoView.imageURL = nil
//        super.prepareForReuse()
//    }
//
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let horizontalMargin: CGFloat = 20
//        let width: CGFloat = bounds.size.width - horizontalMargin * 2
//        let height: CGFloat = (width * 0.9).rounded(.up)
//        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
//    }
//
//
//    func visibleVideoHeight() -> CGFloat {
//        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(videoView.frame, from: videoView)
//        guard let videoFrame = videoFrameInParentSuperView,
//            let superViewFrame = superview?.frame else {
//             return 0
//        }
//        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
//        return visibleVideoFrame.size.height
//    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
