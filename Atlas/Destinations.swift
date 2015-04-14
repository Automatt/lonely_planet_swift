//
//  Destinations.swift
//  Atlas
//
//  Created by Mathew Spolin on 4/1/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import Foundation

class Atlas {
    var destinations: [Destination] = []
    
    func find(atlas_id: String) -> Destination? {
        for place in destinations {
            if place.atlas_id == atlas_id {
                return place
            }
        }
        return nil
    }
}

class Destination {
    var atlas_id = ""
    var title = ""
    var facts: [Fact] = []
}

class Fact {
    var title = ""
    var content = ""
    var position = 0
}

class DestinationParser: NSObject, NSXMLParserDelegate {
    var destinations: [Destination] = []
    
    var foundCharacters = ""
    
    var currentDestination = Destination()
    var currentFact = Fact()
    var currentElementName = ""
    var currentAttributes: NSDictionary = NSDictionary()
    
    func parseDestinations() -> Atlas {
        let filename = "destinations"
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "xml")
        
        if let parser = NSXMLParser(contentsOfURL: url) {
            parser.delegate = self
            parser.parse()
        }
        
        let atlas = Atlas()
        atlas.destinations = destinations
        return atlas
    }
    
    func parseFile(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "xml")
        
        if let parser = NSXMLParser(contentsOfURL: url) {
            parser.delegate = self
            parser.parse()
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject: AnyObject]) {
        
        switch elementName {
        case "destination":
            currentDestination = Destination()
            currentDestination.title = attributeDict["title"] as! String
            currentDestination.atlas_id = attributeDict["atlas_id"] as! String
            destinations.append(currentDestination)
        default:
            break
        }
        
        currentElementName = elementName        
    }
    
    func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {
        currentFact = Fact()
        currentFact.content = NSString(data: CDATABlock, encoding: NSUTF8StringEncoding)! as String
        currentFact.title = currentElementName
        currentDestination.facts.append(currentFact)
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        foundCharacters += string!
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = ""
        
    }
}