//
//  ChannelSettingViewController.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChannelSettingViewController: BaseViewController {
    
    let mainView = ChannelSettingView()
    let viewModel = ChannelSettingViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "채널 설정"
        setTableView()
        fetchData()
        
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func fetchData() {
        viewModel.fetchData {
            self.mainView.tableView.reloadData()
        }
    }
}

extension ChannelSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    //TableViewCell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.isOpened) ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: // section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.description(), for: indexPath) as? SectionTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.infoForSection()
            
            cell.configureCell(count: data.count, expanded: data.expanded)
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberListTableViewCell.description(), for: indexPath) as? MemberListTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.infoForMemberCell()
            cell.items = data
            
            cell.collectionView.reloadData()
            
            cell.setHeight()
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return 56
        case 1: return UITableView.automaticDimension
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //섹션 Open Toggle
        viewModel.toggleSection(indexPath) {
            self.mainView.tableView.reloadData()
        }
    }
    
    //TableViewHeaderFooter
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: InfoHeaderView.description()) as? InfoHeaderView else { return UIView() }
        
        if let data = viewModel.channelInfo {
            header.configureView(name: data.name, info: data.description ?? "")
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ButtonFooterView.description()) as? ButtonFooterView else { return UIView() }
        
        footer.isOwner = viewModel.isOwner
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 237
    }
    
}
