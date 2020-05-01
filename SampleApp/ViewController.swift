//
//  ViewController.swift
//  SampleApp
//
//  Created by 李腾芳 on 2020/4/29.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "语言", style: .done, target: self, action: #selector(selectLanguage))
    }

    @objc func selectLanguage() {
        let alertVC = UIAlertController(title: "选择语言", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "简体中文", style: .default, handler: { _ in
            CopyBundleProvider.shared.languageCode = .zhHans
            self.updateText()
        }))

        alertVC.addAction(UIAlertAction(title: "english", style: .default, handler: { _ in
            CopyBundleProvider.shared.languageCode = .en
            self.updateText()
        }))

        alertVC.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil))

        present(alertVC, animated: true, completion: nil)
    }

    func updateText() {
        titleLabel.text = Strings.Home.helloWorld.localized()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateText()
    }
}
