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
import RealmSwift
import Kingfisher

class HomeTableViewController: UITableViewController {
    var strips:Results<Strip>?
    private lazy var dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        return dateFormatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logContentView(withName: "Home", contentType: "Table View", contentId: nil, customAttributes: nil)
        self.loadData()
        self.loadXMLData()
    }
    
    func loadXMLData(){
        Programmer.shared.getRSSData { (xmlStrips, error) in
            if let xmls = xmlStrips{
                for s in xmls{
                    print(s)
                }
            }
        }
    }
    
    @IBAction func loadData(){
        KVLoading.show()
        Programmer.shared.realmLogin { (success) in
            KVLoading.hide()
            if success{
                let realm = try! Realm()
                self.strips = realm.objects(Strip.self)
                self.tableView.reloadData()
                self.createNotification()
            }else{
                //TODO: error
                //Show localy data
                let realm = try! Realm()
                self.strips = realm.objects(Strip.self)
                self.tableView.reloadData()
            }
        }
    }
    
    var notificationToken: NotificationToken? = nil
    func createNotification(){
        let realm = try! Realm()
        self.strips = realm.objects(Strip.self)
        
        // Observe Results Notifications
        notificationToken = self.strips?.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
            
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
        return strips?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StripTableViewCell
        let strip = strips?[indexPath.row]
        cell.shareButton.strip = strip
        cell.title.text = strip?.title
        cell.pubDate.text = self.dateFormatter.string(from: strip?.pubDate ?? Date())
        cell.shareButton.addTarget(self, action: #selector(self.share(sender:)), for: .touchUpInside)
        cell.shareButton.indexPath = indexPath
        if let photoURL = strip?.imageURL{
            cell.stripImageView.kf.setImage(with: URL(string:photoURL))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! StripTableViewCell
        let strip = strips?[indexPath.row]
        Answers.logContentView(withName:strip?.title , contentType: strip?.imageURL, contentId: nil, customAttributes: nil)
        if let image = cell.stripImageView.image {
            let agrume = Agrume(image: image ,backgroundColor: .black)
            agrume.hideStatusBar = true
            agrume.showFrom(self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StripTableViewCell
        return cell.contentView.frame.size.height
    }
}

extension HomeTableViewController{
    
    @IBAction func share(sender:ShareButton){
        guard let strip = sender.strip else{
            return
        }
        guard let firstActivityItem = strip.title else{
            return
        }
        guard let secondActivityItem = URL(string: strip.link!) else{
            return
        }
        
        guard let image = (tableView.cellForRow(at: sender.indexPath!) as! StripTableViewCell).stripImageView.image else{
            return
        }
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender )
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            .saveToCameraRoll,
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
}


