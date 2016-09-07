//
//  XMLParser.swift
//  IDEAS
//
//  Created by iDeveloper on 8/15/16.
//  Copyright © 2016 Cristi Irascu. All rights reserved.
//

import Foundation

private class ParserDelegate:NSObject, NSXMLParserDelegate{
    init(element:String){
        self.element=element
        super.init()
    }
    
    var text=""
    var element:String
    var recordingElementValue:Bool=false
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        print("element start: \(elementName)")
        if elementName==element{
            recordingElementValue=true
        }
    }
    
    @objc func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("element finish: \(elementName)")
        if elementName==element{
            recordingElementValue=false
        }
    }
    
    @objc func parser(parser: NSXMLParser, foundCharacters string: String) {
        if recordingElementValue{
            text+=string
            
        }
    }
    
}

class XMLParser{
    
    init(xml:String, element:String){
        self.xmlString=xml
        self.parserDelegate=ParserDelegate(element:element)
    }
    
    private var xmlString:String
    var returnValue:String?
    private var parserDelegate:ParserDelegate
    
    func parse()->Bool{
        let p=NSXMLParser(data: xmlString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        p.delegate=parserDelegate
        if p.parse(){
            returnValue=parserDelegate.text
            return true
        }
        return false
    }
}