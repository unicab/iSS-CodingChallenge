//
//  PassTimeController.swift
//  iSS CodingChallenge
//
//  Created by Tam Nguyen on 1/23/18.
//  Copyright © 2018 Tam Nguyen. All rights reserved.
//

import Foundation
import UIKit

class PassTimeController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var timeItems = [ISSPassTimeItem]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "PassTimeController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var didLoadBlock: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.didLoadBlock?()
        self.title = "ISS Passtime"
    }
    
    // present model in UI
    func setModel(_ model: ISSPassTimeModel?) {
        guard let model = model else { return }
        self.timeItems = model.timeItems
        tableView.reloadData()
    }
}

extension PassTimeController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(timeItems[indexPath.row])"
        return cell
    }
}

