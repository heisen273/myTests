//
//  artistTableViewCell.swift
//  PinterestSwift
//
//  Created by Walter White on 2/6/17.
//  Copyright © 2017 Nicholas Tau. All rights reserved.
//

import UIKit

class artistTableViewCell: UITableViewCell {
    @IBOutlet weak var artistPhoto: UIImageView!

    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.artistPhoto.image = self.artistPhoto.image?.circle
        //self.artistPhoto.frame = CGRectMake(0,0,32,32)
        
    }
    
    
    

}
