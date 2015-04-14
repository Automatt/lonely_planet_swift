//
//  PlaceDetailViewController.swift
//  Atlas
//
//  Created by Mathew Spolin on 4/1/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UITableViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageLoadButton: UIButton!
    
    var placeNode: Node = Node()
    var placeDestination: Destination = Destination()
    var factItems: NSMutableArray = []
    
    let factCellIdentifier = "FactCell"
    let flickr = Flickr()
    
    var flickrPhotos = [FlickrSearchResults]()
    var currentImageIndex = 0
    
    var headerView: UIView!
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeImageLabel: UILabel!
    
    private var tableHeaderHeight: CGFloat = 300.0
    private let tableCutAway: CGFloat = 80.0
    
    var headerMaskLayer: CAShapeLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentImageIndex = 0

        if placeNode.atlas_node_id != "" {
            self.navigationItem.title = placeNode.name
        }
        if placeDestination.title != "" {
            loadInitialData()
            loadFlickrImage()
        }
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        let effectiveHeight = tableHeaderHeight - tableCutAway/2

        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left:0, bottom:0, right: 0)
        tableView.contentOffset = CGPoint(x:0, y: -effectiveHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        
    
        
        updateHeaderView()
        
    }
    
    func updateHeaderView() {
        let effectiveHeight = tableHeaderHeight - tableCutAway/2

        var headerRect = CGRect(x:0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableCutAway/2
        }
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x:0, y:0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y:0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y:headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y:headerRect.height - tableCutAway))
        headerMaskLayer?.path = path.CGPath
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    @IBAction func loadImage(sender: AnyObject) {
        showNextImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return factCellAtIndexPath(indexPath)
    }
    
    func factCellAtIndexPath(indexPath: NSIndexPath) -> FactCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(factCellIdentifier) as! FactCell
    
        setTitleForCell(cell, indexPath: indexPath)
        setContentForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setTitleForCell(cell:FactCell, indexPath: NSIndexPath) {
        let item = factItems[indexPath.row] as! Fact
        cell.titleLabel.text = item.title.capitalizedString.replace("_", withString:" ") ?? "[No Title]"
    }
    
    func setContentForCell(cell:FactCell, indexPath: NSIndexPath) {
        let item = factItems[indexPath.row] as! Fact
        cell.contentLabel.text = item.content ?? "[No Content]"
    }
    
    func loadInitialData() {
        for fact in self.placeDestination.facts {
            self.factItems.addObject(fact)
        }
    }
    
    func loadFlickrImage() {

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        placeImageView.addSubview(activityIndicator)
        activityIndicator.frame = placeImageView.bounds
        activityIndicator.startAnimating()
        
        flickr.searchFlickrForTerm(placeNode.name) {
            results, error in
        
            self.imageLoadButton.setTitle("Next Image", forState: .Normal)
            self.flickrPhotos.insert(results!, atIndex:0)
            self.showNextImage()
            
            activityIndicator.removeFromSuperview()
        }
}
    
    func showNextImage() {
        currentImageIndex = currentImageIndex + 1
        if currentImageIndex >= self.flickrPhotos[0].searchResults.count {
            currentImageIndex = 0
        }
        self.flickrPhotos[0].searchResults[currentImageIndex].loadLargeImage {
            photo, error in
            self.placeImageView.image = photo.largeImage
            self.placeImageLabel.text = photo.title
            self.tableHeaderHeight = self.placeImageView.frame.height
            self.updateHeaderView()
        }

       // self.placeImageView.size = self.placeImageView.(CGSize(width: placeImageView.frame.width, height:placeImageView.frame.height))
        
        
    }
}
