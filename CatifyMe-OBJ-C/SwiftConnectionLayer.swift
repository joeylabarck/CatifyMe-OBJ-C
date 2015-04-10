//
//  SwiftConnectionLayer.swift
//  CatifyMe-OBJ-C
//
//  Created by Joey LaBarck on 4/10/15.
//  Copyright (c) 2015 LaBarck. All rights reserved.
//

import UIKit

@objc protocol SwiftConnectionDelegate {
    func receivedNewCatWithSourceURL(image: UIImage, sourceURL: String)
}

@objc class SwiftConnectionLayer: NSObject {
    var delegate:SwiftConnectionDelegate?
    var idString =  ""
    var urlString = ""
    var sourceURLString = ""
    let downloadQueue:NSOperationQueue;
    
    override init() {
        downloadQueue = NSOperationQueue.new()
    }
    
    func getNewCat() {
        let url = NSURL(string: kCatifyMeURLString)
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        NSURLConnection.sendAsynchronousRequest(request, queue: downloadQueue, completionHandler:{
            (response,data,error) in
            if !NSThread.isMainThread() {
                var jsonError:NSError?
                if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil , error:&jsonError) as? NSDictionary {
                    self.parseJSONDictionary(json)
                }
            }
        })
    }
    
    func parseJSONDictionary(dictionary:NSDictionary) {
        if !NSThread.isMainThread() {
            let imageDescriptor:NSDictionary = dictionary.objectForKey(kDataKey)!.objectForKey(kImagesKey)!.objectForKey(kImageKey)! as! NSDictionary
            idString = imageDescriptor.objectForKey(kIDKey)! as! String
            urlString = imageDescriptor.objectForKey(kURLKey)! as! String
            sourceURLString = imageDescriptor.objectForKey(kSourceURLKey)! as! String
            
            var image:UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)!
            delegate?.receivedNewCatWithSourceURL(image, sourceURL: urlString)
        }
    }
}
