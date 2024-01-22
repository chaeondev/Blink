//
//  UIViewController+Extension.swift
//  Blink
//
//  Created by Chaewon on 1/15/24.
//

import UIKit
import SnapKit

extension UIViewController {
    
    // MARK: Transition
    func changeRootViewController(viewController: UIViewController, isNav: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let vc = isNav ? UINavigationController(rootViewController: viewController) : viewController
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKey()
    }
    
    // MARK: Custom Navigation
    func setNavigation(title: String, isLeftButton: Bool = true) {
        navigationItem.title = title
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandWhite
        
        if isLeftButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .done, target: self, action: nil)
            navigationController?.navigationBar.tintColor = .brandBlack
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }
    
    func setCustomNavigationbar(
        customView: UIView,
        left: UIButton,
        title: UIButton,
        right: UIButton,
        blurView: UIView? = nil
    ) {
        guard let navigationBar = navigationController?.navigationBar else {
                    return
                }

        let height = navigationBar.frame.size.height
        let width = navigationBar.frame.size.width
        
        [left, title, right].forEach { customView.addSubview($0) }
    
        if let blurView {
            right.addSubview(blurView)
        }
        
        customView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        left.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        right.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(left.snp.trailing).offset(8)
            make.trailing.equalTo(right.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        if let blurView {
            blurView.layer.cornerRadius = 16
            blurView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            blurView.isHidden = true
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customView)

        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }
    
    func setCustomLargeTitleNavigation(title: String) {
        let titleLabel = UILabel.labelBuilder(text: title, font: .title1, textColor: .brandBlack)
        let titleView = UIView()
        
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
    }
    
    // MARK: Toast
    
    func toast(message: String, pointY: CGFloat) {
        self.view.makeToast(message, duration: 2.0, point: CGPoint(x: view.frame.width / 2, y: pointY), title: nil, image: nil, completion: nil)
    }
    
    func toast(message: String) {
        self.view.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    // MARK: ActionSheet
    func showOneActionSheet(title: String, completion: @escaping () -> Void) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: title, style: .default) { _ in
            completion()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(firstAction)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    func showTwoActionSheet(
        firstTitle: String,
        firstCompletion: @escaping () -> Void,
        secondTitle: String,
        secondCompletion: @escaping () -> Void
    ) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: firstTitle, style: .default) { _ in
            firstCompletion()
        }
        let secondAction = UIAlertAction(title: secondTitle, style: .default) { _ in
            secondCompletion()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(firstAction)
        actionSheet.addAction(secondAction)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    func showFourActionSheet(
        firstTitle: String,
        firstCompletion: @escaping () -> Void,
        secondTitle: String,
        secondCompletion: @escaping () -> Void,
        thirdTitle: String,
        thirdCompletion: @escaping () -> Void,
        fourthTitle: String,
        fourthCompletion: @escaping () -> Void
    ) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: firstTitle, style: .default) { _ in firstCompletion() }
        let secondAction = UIAlertAction(title: secondTitle, style: .default) { _ in secondCompletion() }
        let thirdAction = UIAlertAction(title: thirdTitle, style: .default) { _ in thirdCompletion() }
        let fourthAction = UIAlertAction(title: fourthTitle, style: .destructive) { _ in fourthCompletion() }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(firstAction)
        actionSheet.addAction(secondAction)
        actionSheet.addAction(thirdAction)
        actionSheet.addAction(fourthAction)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    // MARK: Alert
    func showOneActionViewController(title: String, message: String, completion: @escaping () -> Void) {
        let vc = OneAlertViewController()
        vc.setUp(title: title, message: message, completion: completion)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func showTwoActionViewController(
        title: String,
        message: String,
        doCompletion: @escaping () -> Void,
        cancelCompletion: @escaping () -> Void
    ) {
        let vc = TwoAlertViewController()
        vc.setUp(title: title, message: message, doCompletion: doCompletion, cancelCompletion: cancelCompletion)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    
    
}
