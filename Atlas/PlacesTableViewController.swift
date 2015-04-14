//
//  PlacesTableViewController.swift
//  Atlas
//
//  Created by Mathew Spolin on 3/31/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var placesItems: NSMutableArray = []
    var taxonomy = Taxonomy()
    let taxonomyParser = TaxonomyParser()
    
    var destinations: Atlas = Atlas()
    let destinationParser = DestinationParser()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placesItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ListPrototypeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let placeItem = self.placesItems.objectAtIndex(indexPath.row) as! Node
        cell.textLabel?.text = placeItem.name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlaceDetail" {
            let placeDetail = segue.destinationViewController as! PlaceDetailViewController
            if let placeIndex = tableView.indexPathForSelectedRow()?.row {
                let node = placesItems[placeIndex] as! Node
                placeDetail.placeNode = node
                if let destination = destinations.find(node.atlas_node_id) {
                    placeDetail.placeDestination = destination
                }
            }
        }
    }
    
    func loadInitialData() {
        self.taxonomy = taxonomyParser.parseTaxonomy()
        self.destinations  = destinationParser.parseDestinations()
        for node in self.taxonomy.nodes {
            loadNode(node)
        }
        
    }
    
    func loadNode(node: Node) {
        self.placesItems.addObject(node)
        for subnodes in node.nodes {
            loadNode(subnodes)
        }
    }

}
