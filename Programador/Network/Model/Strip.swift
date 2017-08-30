//
//  Strip.swift
//  Programador
//
//  Created by Stefan Thomsen on 19/05/17.
//  Copyright © 2017 Creative Dev. All rights reserved.
//
//  Builder Pattern Example
//

import Foundation
import RealmSwift
import SWXMLHash

struct StripXML {
    var title:String?
    var link:String?
    var pubDate:String?
    var creator:String?
    var description:String?
    var content:String?
    var imageURL:String?
    
    init(fromElement element:XMLIndexer) {
        self.title = element["title"].element!.text
        self.link = element["link"].element!.text
        self.pubDate = element["pubDate"].element!.text
        self.creator = element["dc:creator"].element!.text
    }
}

class Strip: Object {
    dynamic var stripID:String? = nil
    dynamic var title:String? = nil
    dynamic var link:String? = nil
    dynamic var pubDate:Date? = nil
    dynamic var creator:String? = nil
    dynamic var stripDescription:String? = nil
    dynamic var content:String? = nil
    dynamic var imageURL:String? = nil
    
    override static func primaryKey() -> String? {
        return "stripID"
    }
    
    
    convenience init(fromXML xml:StripXML) {
        self.init()
        self.stripID = xml.imageURL
        self.title = xml.title
        self.link = xml.link
        self.imageURL = xml.imageURL
    }
    
}
