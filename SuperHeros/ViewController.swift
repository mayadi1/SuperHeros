//
//  ViewController.swift
//  SuperHeros
//
//  Created by Mohamed on 6/13/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var heroes = [NSDictionary]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//    let heroe1 = ["name": "Alex", "indent": "cool"]
//    let heroe2 = ["name": " ahmed", "indent": "awesome"]
//    heroes = [heroe1, heroe2]
        
        
        let url = NSURL(string: "http://s3.amazonaws.com/mmios8week/superheroes.json")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            do {
                self.heroes = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [[String : String]]
            } catch let error as NSError {
                print("Json ERROR: \(error.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                
            })
        
        }
    task.resume()
    
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        
        let superhero = heroes[indexPath.row]
        
        cell.textLabel?.text = superhero["name"] as? String
        cell.detailTextLabel?.text = superhero["description"] as? String
        
        let url = NSURL(string: superhero["avatar_url"] as! String)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data:NSData? , _, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                cell.imageView?.image = UIImage(data: data!)
                cell.layoutSubviews()
                })
            
            
        }
        task.resume()
        
        return cell
    }
    
    
    

}

