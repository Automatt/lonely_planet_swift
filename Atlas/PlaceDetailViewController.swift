//
//  PlaceDetailViewController.swift
//  Atlas
//
//  Created by Mathew Spolin on 4/1/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    @IBOutlet weak var placeText: UITextView!
    
    var placeNode: Node = Node()
    var placeDestination: Destination = Destination()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if placeNode.atlas_node_id != "" {
            self.navigationItem.title = placeNode.name
        }
        if placeDestination.title != "" {
            placeText.text = placeDestination.facts[0].content
            placeText.sizeToFit()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
