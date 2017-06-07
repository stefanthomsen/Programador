//
//  HomeTableViewController.swift
//  Programador
//
//  Created by Stefan Thomsen on 19/05/17.
//  Copyright © 2017 Creative Dev. All rights reserved.
//

import UIKit
import KVLoading
import Agrume
import Crashlytics



class HomeTableViewController: UITableViewController {

    var strips = [Strip]()
    var error:Error?
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logContentView(withName: "Home", contentType: "Table View", contentId: nil, customAttributes: nil)
        self.loadData()
    }
    
    @IBAction func loadData(){
        KVLoading.show()
        Programmer.getRSSData { (strips,error) in
            KVLoading.hide()
            if let error = error{
                self.error = error
                print(error)
            }else{
                self.strips = strips!
            }
            self.tableView?.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if error != nil {
            return 1
        }
        return strips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if error != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellError")
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StripTableViewCell
        cell.title.text = strips[indexPath.row].title
        cell.configureCell(with: strips[indexPath.row].imageURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if error != nil {
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! StripTableViewCell
        let strip = strips[indexPath.row]
        Answers.logContentView(withName:strip.title , contentType: strip.imageURL, contentId: nil, customAttributes: nil)
        if let image = cell.stripImageView.image {
            let agrume = Agrume(image: image ,backgroundColor: .black)
            agrume.hideStatusBar = true
            agrume.showFrom(self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if error != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellError")
            return cell!.contentView.frame.size.height
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StripTableViewCell
        return cell.contentView.frame.size.height
    }
}


