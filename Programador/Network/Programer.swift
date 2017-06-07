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

typealias CompletionStrips = ((_ strips:[Strip]?,_ error:Error?) -> ())?

class Programmer{
    
    //Singleton
    let shared = Programmer()

    static func getRSSData(completeHandler: CompletionStrips){
        Alamofire.request(feedProgrammerURL)
            .validate(statusCode: 200..<300)
            .responseData { response in
            switch response.result {
            case .success:
                let xml = SWXMLHash.parse(response.data!)
                print(xml)
                var strips = [Strip]()
                for elem in xml["rss"]["channel"]["item"].all {
                    if let doc = HTML(html: elem["content:encoded"].element!.text!, encoding: .utf8) {
                        // Search for nodes by XPath
                        for link in doc.xpath("//img | //link ") {
                            //Check if the link contain a "tirinha" string
                            if let imageLink = link["src"], imageLink.range(of: "tirinha") != nil{
                                var strip = Strip(fromElement: elem)
                                strip.imageURL = imageLink
                                strips.append(strip)
                                break
                            }
                        }
                    }
                }
                completeHandler!(strips,nil)
            case .failure(let error):
                //TODO
                print(error)
                completeHandler!(nil,error)
            }
            
        }
    }
}
