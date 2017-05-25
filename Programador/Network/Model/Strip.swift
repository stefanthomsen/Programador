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
import ImageViewer

protocol StripProtocol {
    var title:String { get }
    var link:String { get }
    var pubDate:String { get }
    var creator:String { get }
    var description:String { get }
    var content:String { get }
    var imageURL:String? { get }
    var galleryItem: GalleryItem { get }
}

class Strip : StripProtocol {
    var title:String = ""
    var link:String = ""
    var pubDate:String = ""
    var creator:String = ""
    var description:String = ""
    var content:String = ""
    var imageURL:String?
    var galleryItem: GalleryItem = GalleryItem.image { $0(UIImage(named: "0")!) }
    typealias buildStripClosure = (Strip) -> Void
    init(build:buildStripClosure) {
        build(self)
    }
}
