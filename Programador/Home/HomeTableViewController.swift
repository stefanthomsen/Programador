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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logContentView(withName: "Home", contentType: "Table View", contentId: nil, customAttributes: nil)
        self.loadData()
    }
    

    
    @IBAction func loadData(){
        KVLoading.show()
        Programmer.getRSSData { (strips) in
            KVLoading.hide()
            self.strips = strips
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
        return strips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StripTableViewCell
        cell.title.text = strips[indexPath.row].title
        cell.configureCell(with: strips[indexPath.row].imageURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! StripTableViewCell
        let strip = strips[indexPath.row]
        Answers.logContentView(withName:strip.title , contentType: strip.imageURL, contentId: nil, customAttributes: nil)
        if let image = cell.stripImageView.image {
            let agrume = Agrume(image: image ,backgroundColor: .black)
            agrume.hideStatusBar = true
            agrume.showFrom(self)
        }
    }
}


