//
//  Programer.swift
//  Programador
//
//  Created by Stefan Thomsen on 19/05/17.
//  Copyright © 2017 Creative Dev. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire
import SWXMLHash
import Kanna

let feedProgrammerURL = "http://vidadeprogramador.com.br/feed/"

typealias CompletionStrips = ((_ strips:[Strip]?,_ error:Error?) -> ())?

let host = "host"
let racePath = "/path/to"

let username = "username"
let password = "password"

class Programmer:NSObject{
    
    //Singleton
    static let shared = Programmer()
    
    var realm = try! Realm()
    
    func realmLogin( completion: @escaping ((Bool)->Void) = {_ in}){
        let credentials = SyncCredentials.usernamePassword(username: username, password: password)
        let serverUrl = URL(string: "http://\(host):9080")!
        
        SyncUser.logIn(with: credentials, server: serverUrl) { user, error in
            guard let user = user else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            var conf = Realm.Configuration.defaultConfiguration
            let url =  URL(string: "realm://\(host):9080\(racePath)")!
            conf.syncConfiguration = SyncConfiguration(user: user, realmURL:url)
            Realm.Configuration.defaultConfiguration = conf
            Realm.asyncOpen(configuration: conf) { realm, error in
                if let realm = realm {
                    // Realm successfully opened, with all remote data available
                    let strips = realm.objects(Strip.self)
                    //print(Realm.Configuration.defaultConfiguration.fileURL)
                    try? self.realm.write() {
                        for r in strips{
                            self.realm.create(Strip.self, value: r, update: true)
                        }
                    }
                    DispatchQueue.main.async { completion(true) }
                } else if let error = error {
                    print(error)
                    // Handle error that occurred while opening or downloading the contents of the Realm
                    DispatchQueue.main.async { completion(false) }
                }
            }
        }
    }
    
    func getRSSData(completeHandler: CompletionStrips){
        Alamofire.request(feedProgrammerURL)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    let xml = SWXMLHash.parse(response.data!)
                    print(xml)
                    var strips = [StripXML]()
                    for elem in xml["rss"]["channel"]["item"].all {
                        if let doc = HTML(html: elem["content:encoded"].element!.text, encoding: .utf8) {
                            // Search for nodes by XPath
                            for link in doc.xpath("//img | //link ") {
                                //Check if the link contain a "tirinha" string
                                if let imageLink = link["src"], imageLink.range(of: "tirinha") != nil{
                                    var strip = StripXML(fromElement: elem)
                                    strip.imageURL = imageLink
                                    strips.append(strip)
                                    break
                                }
                            }
                        }
                    }
                    
                    var realmStrip = [Strip]()
                    for s in strips{
                        realmStrip.append(Strip(fromXML: s))
                    }
                    
                    completeHandler!(realmStrip,nil)
                case .failure(let error):
                    //TODO
                    print(error)
                    completeHandler!(nil,error)
                }
                
        }
    }

}
