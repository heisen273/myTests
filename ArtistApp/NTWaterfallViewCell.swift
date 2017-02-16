//
//  NTWaterfallViewCell.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit

class NTWaterfallViewCell :UICollectionViewCell{
    var needArtistLabel = true
    var imageViewContent : UIImageView = UIImageView()
    var titleLabel = UILabel()
    
    var artistLabelView = UIView()
    var artistLabel = UILabel()
    var artistLabelImage = UIImageView()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        if needArtistLabel == true {
        artistLabelView.addSubview(artistLabel)
        artistLabelView.addSubview(artistLabelImage)
        contentView.addSubview(artistLabelView)
        }
        
        contentView.addSubview(imageViewContent)
        contentView.addSubview(titleLabel)
        
        

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if needArtistLabel == true {
        imageViewContent.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 60)
        titleLabel.frame = CGRect(x: 0, y: frame.size.height - 60, width: frame.size.width, height: 30)
        artistLabel.frame = CGRect(x: 30, y: frame.size.height - 30, width: frame.size.width - 30, height: 30)
        artistLabelImage.frame = CGRect(x: 5, y: frame.size.height - 28, width: 25, height: 25)}
        else{
            imageViewContent.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 30)
            titleLabel.frame = CGRect(x: 0, y: frame.size.height - 30, width: frame.size.width, height: 30)
        }
    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
    
}
