//
//  ViewController.swift
//  HelloRxSwift
//
//  Created by Ranjith Kumar on 7/17/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableview_Strings: UITableView! {
        didSet{
            self.tableview_Strings.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableview_Strings.delegate = self
            tableview_Strings.dataSource = self
        }
    }
    @IBOutlet weak var searchBar_Strings: UISearchBar!
    
    var shownCities = [String]() // Data source for UITableView
    let allCities = ["New York", "London", "Lala", "Oslo", "Warsaw", "Berlin", "Praga"] // Our mocked API data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar_Strings
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait for 0.5 seconds
            .distinctUntilChanged() // If they did not occur, check if new value is the same as old
//            .filter{$0.isEmpty} // If new value is really new, filter for non empty query
            .subscribe(onNext: { [unowned self] query in // Here we will be notified of every new value
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
                self.tableview_Strings.reloadData() // And reload table view data.
            })
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }
}

