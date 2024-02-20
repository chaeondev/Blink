//
//  CoinShopViewController.swift
//  Blink
//
//  Created by Chaewon on 2/20/24.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import iamport_ios

final class CoinShopViewController: BaseViewController {
    
    private let mainView = CoinShopView()
    let viewModel = CoinShopViewModel()
    
    private let disposeBag = DisposeBag()
    
    //테이블뷰 cell button event
    private var cellButtonClicked = PublishSubject<IndexPath>()
    
    //결제창 위한 웹뷰
    lazy var webView: WKWebView = {
        var view = WKWebView(frame: mainView.frame)
        view.backgroundColor = .clear
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavigation(title: "코인샵", isLeftButton: false)

    }
    
    
    func bind() {
        let input = CoinShopViewModel.Input(
            cellButtonClicked: cellButtonClicked
        )
        let output = viewModel.transform(input: input)
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
        
//        cell.moneyButton.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.cellButtonClicked.onNext(indexPath)
//            }
//            .disposed(by: cell.disposeBag)
        cell.moneyButton.addTarget(self, action: #selector(moneyButtonClicked), for: .touchUpInside)
        
        return cell
    }
}

extension CoinShopViewController {
    
    @objc func moneyButtonClicked(_ sender: UIButton) {
        
        setupWebView()
        
        let payment = viewModel.createPaymentData(sender.titleLabel?.text)
        //2. 포트원 SDK에 결제 요청
        Iamport.shared.paymentWebView(webViewMode: webView, userCode: "imp57573124", payment: payment) { [weak self] iamportResponse in
            
            print("======결제창 떠주세여...=======")
            print(String(describing: iamportResponse))
            
        }
    }
    
    func setupWebView() {
        mainView.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(mainView.safeAreaLayoutGuide)
        }
    }
    
}
