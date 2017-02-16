//
//  AppDelegate.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit
import ImageSlideshow
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    /**
     Notifies about access error. For example, this may occurs when user rejected app permissions through VK.com
     */
//    public func vkSdkUserAuthorizationFailed() {
//        print("error")
//    }
//
//    /**
//     Notifies about authorization was completed, and returns authorization result with new token or error.
//     
//     @param result contains new token or error, retrieved after VK authorization.
//     */
//    public func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
//        VKSdk.authorize([])
//    }
    

                            
    var window: UIWindow?
    var rootVC: NTWaterfallViewController!
    var artistVC: artistTableViewController!
    
    let link = "https://gist.github.com/heisen273/e89bbde516143bf09c17e30416d63e9c/raw/5340cb687c6a84b7c0e59753541d5b278170e128/legal"
    
    
   
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        return true
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navigationContorller = self.window?.rootViewController as! UINavigationController
        let tabBar = navigationContorller.topViewController as! UITabBarController
        rootVC = tabBar.customizableViewControllers![0] as! NTWaterfallViewController
        artistVC = tabBar.customizableViewControllers![1] as! artistTableViewController
        get_json()
        
        
        let vkSDK = VKSdk.initialize(withAppId: VKNetworking.kVK_APP_ID)
        vkSDK?.register(VKNetworking.shared)
        vkSDK?.uiDelegate = VKNetworking.shared
        
        
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func extract_json_data(_ data:NSString) {
        
        var image_height = [CGFloat]()
        var image_width = [CGFloat]()
        var imageNameList : Array <NSString> = []
        var image_height_big = [CGFloat]()
        var image_width_big = [CGFloat]()
        var imageNameList_big : Array <NSString> = []
        
        var imageLabels = [[NSString]]()
        var artist_photos = [NSString]()
        
        var artist = [Artist]()
        var artistList = [[String]]()
        //var resources: [Resource] = []
        
        
        let jsonData:Data = data.data(using: String.Encoding.unicode.rawValue)!
        let json: AnyObject?
        
        let authtoken = "12345"
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: authtoken) != nil{
            json = defaults.object(forKey: authtoken) as AnyObject?
        }
        else{
            do
                {
                    json = try JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject!
                    defaults.set(json, forKey: authtoken)

//                    defaults.set(authtoken, forKey: "authtoken")
//                    defaults.synchronize()
                    //json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                }
            catch
                {
                    print("error")
                    return
                }
        }
        
        
                //print(json)
                
            if let array = json! as? [[String: [AnyObject]]]
                {

                    for item in array
                    {
                        
                        let A = Artist()
                        
                        var imageHeight = [CGFloat]()
                        var imageWidth = [CGFloat]()
                        var imageName : Array <String> = []
                        var imageNameBig : Array <String> = []
                        var born = String()
                        var died = String()
                        var ArtistimageLabels = [[String]]()
                        A.name = item.keys.first!
                        
                        
                        if let image_lst = item as? [String: [AnyObject]]{
                            let first = image_lst.keys.first
                            for list in image_lst[first!]!{
                                let width = list["width"] as! CGFloat
                                let height = list["height"] as! CGFloat
                                let artist_photo = list["artist_photo"] as! NSString
                                let link = (list["image"] as! String).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                                let thumb_link = (list["thumbnail"] as! String).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                                var lst = [String]()
                                var sub = [String]()
                                let title = list["title"] as! NSString
                                let date = list["yearAsString"] as! String
                                let author = list["artistName"] as! String
                                lst.append("Title: "+(title as String) as String)
                                lst.append("Artist: "+(author ) as String)
                                lst.append("Date: "+date)
                                imageLabels.append(lst as [NSString])
                                image_height_big.append(height)
                                image_width_big.append(width)
                                image_height.append(height)
                                image_width.append(width)
                                imageNameList.append(thumb_link as! NSString)
                                imageNameList_big.append(link as! NSString)
                                artist_photos.append(artist_photo)
                                ArtistimageLabels.append(lst)
                                imageHeight.append(height)
                                imageWidth.append(width)
                                imageName.append(thumb_link!)
                                imageNameBig.append(link!)
                                born = list["birthDay"] as! String
                                died = list["deathDay"] as! String
                                sub.append(author as String)
                                sub.append(artist_photo as String)
                                if artistList.contains(where: { (list) -> Bool in
                                    if list == sub{
                                        return true
                                    }
                                    else{
                                        return false
                                    }
                                }) == false   { artistList.append(sub)}
                                if A.photo == ""{
                                    A.photo = artist_photo as String
                                    A.born = born
                                    A.died = died
                                   
                                    }
                                }
                            A.imageList = imageName
                            A.imageListBig = imageNameBig
                            A.imageWidth = imageWidth
                            A.imageHeight = imageHeight
                            A.imageLabels = ArtistimageLabels
                            artist.append(A)
                            
                            }
                        
                        
                        }
                    
                    
                    
                }
//        let loader : ImagePrefetcher = ImagePrefetcher(resources: resources)
//        loader.start()
//        
        DispatchQueue.main.async {
            self.initRootVC(imageNameList,imageNameList_big: imageNameList_big,imageWidth:  image_width,imageWidth_big:image_width_big,imageHeight:  image_height,imageHeight_big:  image_height_big, imageLabels: imageLabels, artist_photos:artist_photos, artistList: artistList, artist: artist)
        }
    }
    
    func initRootVC(_ imageNameList:Array <NSString>, imageNameList_big:Array <NSString>, imageWidth:[CGFloat],imageWidth_big:[CGFloat], imageHeight:[CGFloat],imageHeight_big:[CGFloat],imageLabels:[[NSString]], artist_photos: [NSString], artistList: [[String]], artist: [Artist]){
        self.rootVC.artist_photos = artist_photos
        self.rootVC.artist = artist
        
        self.artistVC.artist = artist
        self.artistVC.artistList = artistList
        self.rootVC.setupImages()
        self.rootVC.imageSource = [KingfisherSource(urlString:artist[0].photo)!,KingfisherSource(urlString:artist[2].photo)!, KingfisherSource(urlString:artist[3].photo)!]
        self.rootVC.collectionView?.reloadData()
        self.artistVC.tableView.reloadData()
        
        
    }
    
    func get_json() {
        
        let url:URL = URL(string: link)!
        var request = URLRequest(url:url)
        
        request.timeoutInterval = 10
        
        autoreleasepool {
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                    (data, response, error) in

                    guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                        return
                    }
                    
                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    self.extract_json_data(dataString!)
                    
                })
                
                task.resume()
        }
        
    }

}

