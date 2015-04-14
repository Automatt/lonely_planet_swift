//
//  Taxonomy.swift
//  Atlas
//
//  Created by Mathew Spolin on 3/31/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import Foundation


class Taxonomy {
    var name = ""
    var nodes: [Node] = []
}

class Node: NSObject {
    var atlas_node_id = ""
    var geo_id = ""
    var ethyl_content_object_id = ""
    
    var name = ""
    var nodes: [Node] = []
}

class NodeStack {
    var nodes: [Node] = []
    
    func push(node: Node) {
        nodes.append(node)
    }
    
    func pop() -> Node {
        return nodes.removeLast()
    }
    
    func enclosingNode() -> Node {
        return nodes[nodes.count-1]
    }
}

class TaxonomyParser: NSObject, NSXMLParserDelegate {
    
    var foundCharacters = ""
    var currentElementName = ""
    var currentNode: Node = Node()
    var currentTaxonomy: Taxonomy = Taxonomy()
    var currentAttributes: NSDictionary = NSDictionary()
    
    var nodeStack: NodeStack = NodeStack()
    
    func parseTaxonomy() -> Taxonomy {
        let filename = "taxonomy"
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "xml")
        
        if let parser = NSXMLParser(contentsOfURL: url) {
            parser.delegate = self
            parser.parse()
        }
        return self.currentTaxonomy
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject: AnyObject]) {
        
        currentElementName = elementName
        currentAttributes = attributeDict
        
        switch currentElementName {
        case "node":
            currentNode = Node()
            currentNode.atlas_node_id = currentAttributes["atlas_node_id"] as! String
            currentNode.geo_id = currentAttributes["geo_id"] as! String
            currentNode.ethyl_content_object_id = currentAttributes["ethyl_content_object_id"] as! String
            
            if nodeStack.nodes.count == 0 {
                currentTaxonomy.nodes.append(currentNode)
            } else {
                nodeStack.enclosingNode().nodes.append(currentNode)
            }
            
            nodeStack.push(currentNode)
            
        case "taxonomy":
            currentTaxonomy = Taxonomy()
            
        default:
            break
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        foundCharacters += string!
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        var contents = foundCharacters.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        switch elementName {
            
        case "taxonomy_name":
            currentTaxonomy.name = contents
            
        case "node_name":
            currentNode.name = contents
            
        case "node":
            nodeStack.pop()
            
        default:
            break
        }
        
        foundCharacters = ""
    }
}
