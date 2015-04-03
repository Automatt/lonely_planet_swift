//
//  PlaceDetailViewController.swift
//  Atlas
//
//  Created by Mathew Spolin on 4/1/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UITableViewController {
    
    var placeNode: Node = Node()
    var placeDestination: Destination = Destination()
    var factItems: NSMutableArray = []
    let factCellIdentifier = "FactCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()

        if placeNode.atlas_node_id != "" {
            self.navigationItem.title = placeNode.name
        }
        if placeDestination.title != "" {
           loadInitialData()
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(factCellIdentifier) as FactCell
    
        setTitleForCell(cell, indexPath: indexPath)
        setContentForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setTitleForCell(cell:FactCell, indexPath: NSIndexPath) {
        let item = factItems[indexPath.row] as Fact
        cell.titleLabel.text = item.title.capitalizedString.replace("_", withString:" ") ?? "[No Title]"
    }
    
    func setContentForCell(cell:FactCell, indexPath: NSIndexPath) {
        let item = factItems[indexPath.row] as Fact
        cell.contentLabel.text = item.content ?? "[No Content]"
    }
    
    func loadInitialData() {
        for fact in self.placeDestination.facts {
            self.factItems.addObject(fact)
        }
    }
}
