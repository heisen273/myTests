//
//  ViewController.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit
import SDWebImage
import Infinity
import IDMPhotoBrowser
import ImageSlideshow
import Kingfisher
import VK_ios_sdk





let waterfallViewCellIdentify = "waterfallViewCellIdentify"

// move to separated file

func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}




class NTWaterfallViewController : UICollectionViewController, CHTCollectionViewDelegateWaterfallLayout,  IDMPhotoBrowserDelegate {
    /**
     Notifies about access error. For example, this may occurs when user rejected app permissions through VK.com
     */
  
    
    
    
    var artist_photos = [NSString]()
    let layout = CHTCollectionViewWaterfallLayout()
    var needLabel = true
    var numberOfItemsPerSection = 10
    var allImagesBig = [String]()
    var allImages = [String]()
    var allLabels = [[String]]()
    var allImagesHeight = [CGFloat]()
    var allImagesWidth = [CGFloat]()
    var artistName: String?// = "Albrecht Durer"
    var artist = [Artist]()
    var images = Array<IDMPhoto>()
    
    var imageSource = [KingfisherSource]()
    @IBOutlet weak var slideShow: ImageSlideshow!
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//            VKNetworking.shared.vkLogout()
            VKNetworking.shared.vkLogin { (false) in
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            }
        
        

        let Req: VKRequest! = VKApi.groups().getById([VK_API_GROUP_ID: "140395347"])
        Req.execute(resultBlock: { ( response ) in
            print(response!.json)
        }) { (error ) in
            print(error!)
        }}
        
        
        //        Req.execute(resultBlock: { (response) in
//                if response != nil {
//                    print("VK photoRequest result: \(response!.json)")}
//            }

        
        
        
            
     
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        if artistName == nil{
            layout.top = slideShow.frame.height
        }
        else{
            layout.top = 0
        }
    }
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        print("olesia")
        
        if slideShow != nil{
            setupSlideShow()
        }
        SDWebImageDownloader.shared().maxConcurrentDownloads = 3        
        self.setupInfiniteScroll()
        layout.headersAttributes.setValue(slideShow, forKey: "slide")
        
        self.collectionView?.setCollectionViewLayout(layout, animated: false)
        
        self.collectionView?.register(NTWaterfallViewCell.self, forCellWithReuseIdentifier: waterfallViewCellIdentify)
        
    }
    
    
    
    
    func setupImages(){
        
        if artistName == nil{
            for item in artist{
                for image in item.imageListBig{
                    allImagesBig.append(image)
                    images.append(IDMPhoto(url: URL(string: image.components(separatedBy: "!")[0] as String)))
                    
                    imageSource.append(KingfisherSource(urlString: item.photo)!)
                    break
                }
                for image in item.imageList{
                    allImages.append(image)
                    
                    break
                }
                for label in item.imageLabels{
                    allLabels.append(label)
                    print(images.endIndex - 1 )
                    images[images.endIndex - 1].caption = label[0].components(separatedBy: "Title: ")[1]
                    //images[1].
                    
                    break
                }
                for height in item.imageHeight{
                    allImagesHeight.append(height)
                    break
                }
                for width in item.imageWidth{
                    allImagesWidth.append(width)
                    break
                }
            }
        }
        else{
            for item in artist{
                if item.name == artistName{
                    for image in item.imageList{
                        allImages.append(image)
                        images.append(IDMPhoto(url: URL(string: image.components(separatedBy: "!")[0] as String)))
                    }
                    for image in item.imageListBig{
                        allImagesBig.append(image)
                    }
                    for label in item.imageLabels{
                        allLabels.append(label)
                        images[allLabels.endIndex - 1].caption = label[0].components(separatedBy: "Title: ")[1]
                    }
                    for height in item.imageHeight{
                        allImagesHeight.append(height)
                    }
                    for width in item.imageWidth{
                        allImagesWidth.append(width)
                    }
                }
            }
        }
        self.collectionView?.reloadData()
    }
    
    func setupSlideShow(){
        imageSource = [KingfisherSource(urlString: "https://uploads5.wikiart.org/images/volodymyr-orlovsky/ukrainian-landscape-1882.jpg")!, KingfisherSource(urlString: "https://uploads0.wikiart.org/images/ernest-meissonier/dimanche-poissy-1851.jpg")!,  KingfisherSource(urlString: "https://uploads3.wikiart.org/images/thomas-cole/landscape-with-figures-a-scene-from-the-last-of-the-mohicans-1826.jpg")!, KingfisherSource(urlString: "https://uploads0.wikiart.org/images/yosa-buson/chimaki-by-matsumura-goshun-painting-and-yosa-buson-calligraphy.jpg")!, KingfisherSource(urlString: "https://uploads1.wikiart.org/images/volodymyr-orlovsky/a-road-1881.jpg")!]
        slideShow.backgroundColor = UIColor.white
        slideShow.slideshowInterval = 3.0
        slideShow.pageControl.isHidden = true
        slideShow.pageControl.isEnabled = false
        slideShow.pageControlPosition = .hidden
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideShow.setImageInputs(imageSource)
        
    }
    
    func setupInfiniteScroll() {
        
        let collection :UICollectionView = self.collectionView!
        collection.frame = screenBounds
        let animator = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        collection.fty.infiniteScroll.add(animator: animator){ [] in
            print("odin")
            print(self.numberOfItemsPerSection)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                collection.performBatchUpdates({
                    
                    let row_index = self.numberOfItemsPerSection
                    
                    if ((self.numberOfItemsPerSection)+10) > (self.allImages.count)
                    {
                        
                        if self.allImages.count<10{
                            self.numberOfItemsPerSection = (self.allImages.count)
                            self.collectionView?.fty.infiniteScroll.isEnabled = false
                        }
                        
                        print(self.numberOfItemsPerSection)
                        print(self.allImages.count)
                        if self.allImages.count > self.numberOfItemsPerSection{
                            for i in 0..<((self.allImages.count) - (self.numberOfItemsPerSection) ){
                                let array = [IndexPath(row: row_index+i, section: 0)]
                                collection.insertItems(at: array )
                            }
                            self.numberOfItemsPerSection = (self.allImages.count)
                            self.collectionView?.fty.infiniteScroll.isEnabled = false
                        }
                        self.numberOfItemsPerSection = (self.allImages.count)
                        self.collectionView?.fty.infiniteScroll.isEnabled = false
                    }
                    else{
                        self.numberOfItemsPerSection += 10
                        for i in 0..<10{
                            let array = [IndexPath(row: row_index+i, section: 0)]
                            collection.insertItems(at: array )
                        }
                    }
                    
                    
                }, completion: {
                    finished in
                    print("reload")})
                collection.fty.infiniteScroll.end()
            }
        }

        
    }
    
    
    // MARK: CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
        let cellHeight = allImagesHeight[indexPath.row]*gridWidth / allImagesWidth[indexPath.row] + 50
        return CGSize(width: gridWidth, height: cellHeight)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionCell: NTWaterfallViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: waterfallViewCellIdentify, for: indexPath) as! NTWaterfallViewCell
//        
        var url = URL(string: allImages[indexPath.row])
        
        let image_block: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
            if cacheType == SDImageCacheType.none{
                collectionCell.imageViewContent.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    collectionCell.imageViewContent.alpha = 1
                })}
            else{
                collectionCell.imageViewContent.alpha = 1
            }
            
            
            if (image == nil){
                url = URL(string:self.allImages[indexPath.row].components(separatedBy: "!")[0])
                collectionCell.imageViewContent.sd_setImage(with: url, placeholderImage: getImageWithColor(color:UIColor.lightText, size:CGSize(width: self.allImagesWidth[indexPath.row], height: self.allImagesHeight[indexPath.row])), options: [])
            }
        }
        
    
        
        let avatar_block: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
            collectionCell.artistLabelImage.image = image?.circle
            if cacheType == SDImageCacheType.none{
                collectionCell.artistLabelImage.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    collectionCell.artistLabelImage.alpha = 1
                })}
            else{
                collectionCell.artistLabelImage.alpha = 1
            }
        }
        
        
        
        
          
        collectionCell.imageViewContent.sd_setImage(with: url, completed: image_block)
        
        collectionCell.layer.borderColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0).cgColor
        collectionCell.layer.borderWidth = 1.2
        collectionCell.titleLabel.textAlignment = NSTextAlignment.center
        collectionCell.titleLabel.text = self.allLabels[indexPath.row][0].components(separatedBy: ":")[1]
        
        collectionCell.titleLabel.font = collectionCell.titleLabel.font.withSize(12)
        collectionCell.titleLabel.layer.borderWidth = 1.2
        collectionCell.titleLabel.layer.borderColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0).cgColor
        collectionCell.titleLabel.backgroundColor = UIColor.white
        
        
        if self.needLabel == false{
            collectionCell.needArtistLabel = false
        }
        if artistName == nil{
            
            
            collectionCell.artistLabelImage.sd_setImage(with: URL(string: self.artist[indexPath.row].photo), placeholderImage: getImageWithColor(color:UIColor.lightText, size:CGSize(width: 25, height: 25)), options: [], completed: avatar_block)

            collectionCell.artistLabel.text = allLabels[indexPath.row][1].components(separatedBy: ":")[1]
            collectionCell.artistLabel.font = collectionCell.artistLabel.font.withSize(10)
            collectionCell.artistLabel.backgroundColor = UIColor.white
            collectionCell.artistLabelImage.backgroundColor = UIColor.white
            collectionCell.artistLabelView.backgroundColor = UIColor.white
        }

        return collectionCell;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        //return allImages.count
        
        if numberOfItemsPerSection > allImages.count
        {
            return allImages.count
        }
        else
        {
            return self.numberOfItemsPerSection
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

        
        print(images[indexPath.row].photoURL)
        //print(images[indexPath.row].caption)
        
        let browser: IDMPhotoBrowser! = IDMPhotoBrowser(photos: images)
        browser.displayCounterLabel = true
        browser.displayDoneButton = false
        browser.usePopAnimation = true
//        let label = UILabel()
//        label.text = "ololo"
        browser.displayActionButton = false
        //browser.leftArrowImage = UIImage(named:"IDMPhotoBrowser_heart_like@2x.png")
        browser.actionButtonTitles = ["like"]
        //browser.displayLikeButton = true
        
        //browser.likeImage = UIImage(named: "14810407438952.jpg")
        browser.delegate = self
        browser.setInitialPageIndex(UInt(indexPath.row))
        
        self.present(browser, animated: true, completion: nil)
        
    }
    
    
    
    func photoBrowser(_ photoBrowser: IDMPhotoBrowser!, didShowPhotoAt index: UInt) {
        let position : UICollectionViewScrollPosition =
            UICollectionViewScrollPosition.centeredHorizontally.intersection(.centeredVertically)
        print(artistName)
        
        
        let currentIndexPath = IndexPath(row: Int(index), section: 0)
        let collectionView = self.collectionView!;
            collectionView.setToIndexPath(currentIndexPath)
        if Int(index) >= self.numberOfItemsPerSection{
            self.numberOfItemsPerSection += 10
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
        if index<2{
            return
        }else{
            collectionView.scrollToItem(at: currentIndexPath, at: position, animated: true)
        }
        
        
        
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        self.collectionView?.fty.infiniteScroll.remove()
        self.collectionView?.fty.clear()
    }
}



