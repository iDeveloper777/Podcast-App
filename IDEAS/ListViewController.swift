//
//  ListViewController.swift
//  IDEAS
//
//  Created by iDeveloper on 8/16/16.
//  Copyright © 2016 Cristi Irascu. All rights reserved.
//
import UIKit

import Foundation

let podcast_URL = "https://www.ideasbyelliot.com/ideas-by-elliot-podcast.xml"

class ListViewController: UIViewController, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableList: UITableView!
    @IBOutlet weak var act_Indicator: UIActivityIndicatorView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        act_Indicator.center = self.view.center
        act_Indicator.hidden = true
        
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(ListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
//        tableList.addSubview(refreshControl)
        
        getXMLData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // getXMLData
    func getXMLData(){
        self.act_Indicator.startAnimating()
        self.act_Indicator.hidden = false
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: podcast_URL)!) { data, response, error in
            if error != nil {
                self.act_Indicator.stopAnimating()
                self.act_Indicator.hidden = true
                
                print(error)
                return
            }
            
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            if parser.parse() {
                
                print("complete")
            }
        }
        task.resume()
    }
    
    var postList:NSMutableArray?
    var elementValue: XMLData?
    var success = false
    var item = 0
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        // begin
        if elementName == "rss" {
            postList = NSMutableArray()
        }
        // one item begin
        if elementName == "item" {
            success = true
            elementValue = XMLData()
        }
        
        if success == true{
            switch elementName {
            case "title":
                item = 1
            case "link":
                item = 2
            case "description":
                item = 3
            case "enclosure":
                elementValue!.enclosure_url = attributeDict["url"]!
                //                    print (attributeDict["url"])
                item = 4
            case "pubDate":
                item = 5
            case "itunes:image":
                elementValue!.image_url = attributeDict["href"]!
                
                item = 6
            default:
                item = 0
            }
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if elementValue != nil {
            switch item {
            case 1:
                elementValue!.title = string
            case 2:
                elementValue!.link = string
            case 3:
                elementValue!.description = string
            case 5:
                elementValue!.pubDate = string
            default:
                break
            }
            item = 0
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //one itme end
        if elementName == "itunes:order" {
            postList!.addObject(elementValue!)
            
            success = false;
            elementValue = nil;
            item = 0
        }
        
        //end
        if elementName == "rss"{
            tableList.reloadData()
            self.act_Indicator.stopAnimating()
            self.act_Indicator.hidden = true
            print("dd")
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.act_Indicator.stopAnimating()
        self.act_Indicator.hidden = true
        print("parseErrorOccurred: \(parseError)")
    }
    
    //UITableView delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{

        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postList == nil{
            return 0
        }else {
            return Int(postList!.count)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableList.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        let podcast : XMLData = postList![Int(indexPath.row)] as! XMLData
        let imageURL = NSURL(string:podcast.image_url)
        let imgThumb = cell.viewWithTag(100) as? UIImageView
        imgThumb?.sd_setImageWithURL(imageURL, placeholderImage: nil)
        
        let lblTitle = cell.viewWithTag(200) as? UILabel
        lblTitle?.text = podcast.title
        
        let lblDescription = cell.viewWithTag(300) as? UILabel
        lblDescription?.text = podcast.description
        lblDescription?.numberOfLines = 5
        lblDescription?.sizeToFit()

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let podcast : XMLData = postList![Int(indexPath.row)] as! XMLData
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("PlayViewcController") as! PlayViewcController
        viewController.xmlData = podcast
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }

//    func refresh(sender:AnyObject)
//    {
//        // Updating your data here...
//        getXMLData()
////        self.tableList.reloadData()
////        self.refreshControl.endRefreshing()
//    }
}

