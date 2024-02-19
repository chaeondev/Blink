//
//  CoinShopViewController.swift
//  Blink
//
//  Created by Chaewon on 2/20/24.
//

import UIKit

final class CoinShopViewController: BaseViewController {
    
    private let mainView = CoinShopView()
    let viewModel = CoinShopViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavigation(title: "코인샵", isLeftButton: false)
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension CoinShopViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinShopTableViewCell.description(), for: indexPath) as? CoinShopTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.coinDataForCell(indexPath)
        
        cell.configureCell(data)
        
        return cell
    }
}
