//
//  HomeTableViewController.swift
//  Programador
//
//  Created by Stefan Thomsen on 19/05/17.
//  Copyright © 2017 Creative Dev. All rights reserved.
//

import UIKit
import ImageViewer

class HomeTableViewController: UITableViewController {

    var strips = [Strip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Programmer.getRSSData { (strips) in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath.row, animated: true)
        //TODO: Show Image Full Screen
    }
}


