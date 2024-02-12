//
//  ChattingViewController.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class ChattingViewController: BaseViewController {
    
    private let mainView = ChattingView()
    let viewModel = ChattingViewModel()
    
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setNavigationBar()
        setTableView()
        
        view.backgroundColor = .backgroundSecondary
        
        bind()
        
        loadData()
        
        //mainView.senderView.updateView(images: ["",""])
    }
    
    private func setTableView() {
        mainView.messageTableView.delegate = self
        mainView.messageTableView.dataSource = self
    }
    
    private func bind() {
        //네비게이션 -> 채널 설정으로 가는 버튼
        navigationItem.rightBarButtonItem!.rx.tap
            .bind(with: self) { owner, _ in
                let vc = ChannelSettingViewController()
                vc.viewModel.channelInfo = owner.viewModel.channelInfo
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        //senderView textView 특정 사이즈 이상 스크롤
        mainView.senderView.textView.rx
            .didChange
            .subscribe(with: self) { owner, _ in
                let size = CGSize(width: owner.mainView.senderView.textView.frame.width, height: .infinity)
                let estimatedSize = owner.mainView.senderView.textView.sizeThatFits(size)
                //print("====estimatedSize==== \(estimatedSize.height)")
                // 3줄이면 47
                let isMax = estimatedSize.height >= 50
                owner.mainView.senderView.textView.isScrollEnabled = isMax
                owner.mainView.senderView.remakeTextViewLayout(isMax: isMax)

            }
            .disposed(by: disposeBag)
        
        //senderView textView placeholder
        mainView.senderView.textView
            .rx
            .didBeginEditing
            .subscribe(with: self) { owner, _ in
                if owner.mainView.senderView.textView.text == "메세지를 입력하세요" {
                    owner.mainView.senderView.textView.text = nil
                    owner.mainView.senderView.textView.textColor = .textPrimary
                }
            }
            .disposed(by: disposeBag)
        
        mainView.senderView.textView
            .rx
            .didEndEditing
            .subscribe(with: self) { owner, _ in
                if owner.mainView.senderView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.mainView.senderView.textView.text = "메세지를 입력하세요"
                    owner.mainView.senderView.textView.textColor = .textSecondary
                }
            }
            .disposed(by: disposeBag)
        
        //POST 사진 데이터 collectionView
        viewModel.photoItems
            .bind(with: self) { owner, data in
                owner.mainView.senderView.updateView(images: data)
            }
            .disposed(by: disposeBag)
        
        mainView.senderView.plusButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showPhotoLibrary()
            }
            .disposed(by: disposeBag)
    }
    
    func loadData() {
        viewModel.loadData {
            self.mainView.messageTableView.reloadData()
            self.scrollToUnreadMessage()
        }
    }
    

}

// MARK: TableView
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.description(), for: indexPath) as? ChattingTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.dataForRowAt(indexPath)
        
        cell.configureCell(data)
        
        return cell
    }
    
    //loadData completion으로 들어갈것 -> 안읽은 메세지 처음것부터 보여주기
    func scrollToUnreadMessage() {
        if viewModel.scrollIndex != -1 {
            let row = viewModel.scrollIndex
            
            let indexPath = IndexPath(row: row, section: 0)
            
            self.mainView.messageTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
        //else 일떼 굳이 지정해야함? 어차피 없는데..
    }
}

// MARK: PHPicker
extension ChattingViewController: PHPickerViewControllerDelegate {
    
    func showPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.selection = .ordered
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let selectedItemCnt = viewModel.photoItems.value.count
        let enableCnt = 5 - selectedItemCnt
        if results.count > enableCnt {
            print("===사진은 최대 5개 이하로 선택 가능합니다===")
//            showOneActionViewController(title: "사진 갯수 제한", message: "사진은 최대 5개 이하로 선택 가능합니다.") {
//                self.dismiss(animated: true)
//            }
            picker.dismiss(animated: true)
            return
        }
        
        picker.dismiss(animated: true)
        
        var group = DispatchGroup()
        var dataArr = Array(repeating: Data(), count: results.count)
        
        if !(results.isEmpty) {
            
            for (index, item) in results.enumerated() {
                
                group.enter()
                
                let itemProvider = item.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        
                        guard let image = image as? UIImage else { return }
                        
                        guard let imageData = image.jpegData(compressionQuality: 0.01) else { return }
                        
                        dataArr[index] = imageData
                        
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            
            guard let self else { return }
            
            var photoData = self.viewModel.photoItems.value
            photoData.append(contentsOf: dataArr)
            
            self.viewModel.photoItems.accept(photoData)
        }
    }
}

extension ChattingViewController {
    
    private func setNavigationBar() {
        title = "#\(viewModel.channelInfo.name)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .list, style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .brandBlack
        navigationItem.backButtonDisplayMode = .minimal
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandWhite.withAlphaComponent(0.75)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }
}
