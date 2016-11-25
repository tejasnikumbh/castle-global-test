//
//  MainViewController.swift
//  iOS Test
//
//  Created by Deniz Aydemir on 8/22/16.
//  Copyright © 2016 Castle. All rights reserved.
//

import UIKit
import Alamofire

class CGMainViewController: UIViewController, UISearchBarDelegate {
    
    var wikiEntries: [CGWikiEntry] = []
    
    let searchField = UISearchBar()
    var resultsTableView: UITableView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(searchField)
        self.searchField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: self.searchField, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.searchField, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.searchField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: self.searchField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        ])
        self.searchField.placeholder = "I want to learn about..."
        self.searchField.searchBarStyle = .minimal
        self.searchField.delegate = self
        setupTableView()
        
    }
    
    func setupTableView() {
        resultsTableView = UITableView(frame: CGRect(x: 0, y: 64.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        resultsTableView?.delegate = self
        resultsTableView?.dataSource = self
        resultsTableView?.separatorInset = UIEdgeInsets.zero
        resultsTableView?.separatorStyle = .none
        resultsTableView?.register(UINib.init(nibName: "CGResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "CGResultsTableViewCellIdentifier")
        self.view.addSubview(resultsTableView!)
    }
    
    // MARK:- Search Bar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Make an API Call and refresh the entries based on the text
        CGNetworkingManager.sharedInstance.loadResults(queryString: searchText, completion: {
            (entries) in
            self.wikiEntries = entries
            DispatchQueue.main.async {
                self.resultsTableView!.reloadData()
            }
        })
    }

}

extension CGMainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wikiEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0 // Matching the Nib Size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.resultsTableView?.dequeueReusableCell(withIdentifier: CGConstants.Identifier.TableView.cell) as! CGResultsTableViewCell
        let model = wikiEntries[indexPath.row]
        cell.title.text = model.title
        cell.subTitle.text = model.summary
        guard model.thumbnailImageURL != nil else {
            cell.thumbnailLeftConstraint.constant = 0 
            cell.thumbnailWidthConstraint.constant = 0
            return cell
        }
        cell.thumbnailLeftConstraint.constant = 16.0
        cell.thumbnailWidthConstraint.constant = 80.0
        // Move to a background thread to do some long running work
        DispatchQueue.global(qos: .userInitiated).async {
            _ = model.fetchThumbnailImage(completion: { (image) in
                DispatchQueue.main.async {
                    cell.thumbnail.image = image
                }
            })
        }
        return cell
    }
}

