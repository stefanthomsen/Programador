//
//  Programer.swift
//  Programador
//
//  Created by Stefan Thomsen on 19/05/17.
//  Copyright © 2017 Creative Dev. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash
import Kanna

let feedProgrammerURL = "http://vidadeprogramador.com.br/feed/"

typealias CompletionStrips = (([Strip]) -> ())?

class Programmer{
    
    //Singleton
    let shared = Programmer()

    static func getRSSData(completeHandler: CompletionStrips){
        Alamofire.request(feedProgrammerURL).response { response in
            let xml = SWXMLHash.parse(response.data!)
            print(xml)
            var strips = [Strip]()
            for elem in xml["rss"]["channel"]["item"].all {
                let strip = Strip(build: {
                    $0.title = elem["title"].element!.text!
                    $0.content = elem["content:encoded"].element!.text!
                    if let doc = HTML(html: elem["content:encoded"].element!.text!, encoding: .utf8) {
                        // Search for nodes by XPath
                        for link in doc.xpath("//img | //link | //tirinha") {
                            //Check if the link contain a "tirinha" string
                            if link["src"]?.range(of: "tirinha") != nil{
                                $0.imageURL = link["src"]!
                                print(link["src"]!)
                                break
                            }
                        }
                    }
                })
                
                strips.append(strip)
            }
            completeHandler!(strips)
        }
    }
}
