//
//  List.swift
//  ListViews
//
//  Created by Everis on 04-09-17.
//  Copyright © 2017 Felipe. All rights reserved.
//

import UIKit

class List: NSObject,NSCoding {

    //MARK: Properties
    var storyTitle:String?
    var author:String?
    var createdAt:String?
    var storyUrl:String?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("lists")
    
    //MARK: Initialization
    init(storyTitle:String, author:String, createdAt:String, storyUrl:String){
        self.storyTitle = storyTitle
        self.author = author
        self.createdAt = createdAt
        self.storyUrl = storyUrl
    }
    
    //MARK: NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.storyTitle, forKey: "story_title")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.createdAt, forKey: "created_at")
        aCoder.encode(self.storyUrl, forKey: "story_url")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.storyTitle = aDecoder.decodeObject(forKey: "story_title") as? String
        self.author = aDecoder.decodeObject(forKey: "author") as? String
        self.createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        self.storyUrl = aDecoder.decodeObject(forKey: "story_url") as? String
        
    }

    
}
