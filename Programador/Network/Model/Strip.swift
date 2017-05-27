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
import SWXMLHash

struct Strip {
    var title:String?
    var link:String?
    var pubDate:String?
    var creator:String?
    var description:String?
    var content:String?
    var imageURL:String?
    
    init(fromElement element:XMLIndexer) {
        self.title = element["title"].element!.text!
        self.link = element["link"].element!.text!
    }
}
