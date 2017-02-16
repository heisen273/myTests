//
//  artistTableViewController.swift
//  PinterestSwift
//
//  Created by Walter White on 2/6/17.
//  Copyright © 2017 Nicholas Tau. All rights reserved.
//

import UIKit
import SDWebImage
import VK_ios_sdk


extension artistTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filtered_artists.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        var tableData = [String]()
        for item in artist{
            tableData.append(item.name)
        }
        
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filtered_artists = array as! [String]
        self.tableView.reloadData()
    }
}

class artistTableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {

    var resultSearchController = UISearchController()
    var artistList = [[String]]()
    var numberOfItemsPerSection = 15
    var artist = [Artist]()
    var searchActive : Bool = false
    var filtered_artists = [String]()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true
        self.edgesForExtendedLayout = []
        

        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.showsCancelButton = false
            controller.searchResultsUpdater = self
            controller.searchBar.showsScopeBar = false
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        self.resultSearchController.delegate = self
        self.resultSearchController.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        var contentOffset = tableView.contentOffset
        contentOffset.y += self.resultSearchController.searchBar.frame.size.height
        
        tableView.contentOffset = contentOffset
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive) {
            return self.filtered_artists.count
        }
        else {
            return self.artist .count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : artistTableViewCell
        
        
        if (self.resultSearchController.isActive) {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! artistTableViewCell
            
            cell.artistLabel?.text = filtered_artists[indexPath.row]//.name
            for item in artist{
                if filtered_artists[indexPath.row] == item.name{
                    cell.yearLabel.text = item.born + " – " + item.died
                }
            }
            
            
            let block: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                cell.artistPhoto?.image = image?.circle
                if cacheType == SDImageCacheType.none{
                    cell.artistPhoto.alpha = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.artistPhoto.alpha = 1
                    })}
                else{
                    cell.artistPhoto.alpha = 1
                }
            }
            
            var url = URL(string:"")
            for item in artist{
                if item.name == filtered_artists[indexPath.row]{
                    url = URL(string: item.photo)!
                }
            }
            
            cell.artistPhoto.sd_setImage(with: url, placeholderImage: nil, options: [.cacheMemoryOnly], completed: block)
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! artistTableViewCell
        
        
            let block: SDExternalCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                cell.artistPhoto?.image = image?.circle
                if cacheType == SDImageCacheType.none{
                    cell.artistPhoto.alpha = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.artistPhoto.alpha = 1
                    })}
                else{
                    cell.artistPhoto.alpha = 1
                }
            }
        cell.artistLabel?.text = artist[indexPath.row].name// List[indexPath.row][0] as String
        cell.yearLabel.text = artist[indexPath.row].born + " - " + artist[indexPath.row].died
        let placeholder = getImageWithColor(color:UIColor.lightGray, size:CGSize(width: 100, height: 100)).circle
        
            cell.artistPhoto?.sd_setImage(with: URL(string:artist[indexPath.row].photo), placeholderImage: placeholder, options: [], completed: block)}
        return cell
    }
    
    
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var name : String
        let layout = CHTCollectionViewWaterfallLayout()
        let VC = NTWaterfallViewController(collectionViewLayout: layout)
        VC.collectionView?.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        
        if self.resultSearchController.isActive {
            
            name = filtered_artists[indexPath.row]
            for item in artist{
                if item.name == name{
                    VC.artist = [item]
                }
            }
            
        }
        else {
            name = artist[indexPath.row].name
            VC.artist = [artist[indexPath.row]]
        }
        VC.artistName = name
        
        VC.numberOfItemsPerSection = 10
        VC.needLabel = false        
        VC.slideShow = nil
        VC.setupImages()
        VC.navigationController?.navigationItem.title = name
        VC.title = name
        if VKSdk.isLoggedIn(){
            DispatchQueue.main.async {
                self.navigationController!.pushViewController(VC, animated: true)
            }
        }
        else{
            VKNetworking.shared.vkLogin { (true) in
               
            }
            
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        }
        
        
        
    }
}
