//
//  ConfigViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/25.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import SnapKit

class ConfigViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Tableで使用する配列を定義する.
    private let shutterSoundItems: NSArray = ["iOS9","iOS8", "iOS7", "iOS6", "iOS5", "iOS4"]
    
    // Sectionで使用する配列を定義する.
    private let sections: NSArray = ["シャッター音"]
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    let homeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera"), for: .normal)
        return button
    }()
    let borderUnderHeader: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 49, width: UIScreen.main.bounds.size.width, height: 1.0)
        layer.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
        return layer
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "設定"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    let tableView: UITableView = {
        let table = UITableView.init(frame: CGRect(x: 50, y: 0, width: 0, height: 0), style: UITableViewStyle(rawValue: 1)!)
        table.backgroundColor = .black
        table.separatorInset = UIEdgeInsets.zero
        table.separatorColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        view.addSubview(headerView)
            headerView.addSubview(titleLabel)
            headerView.addSubview(homeButton)
            headerView.layer.addSublayer(borderUnderHeader)
        view.addSubview(tableView)
        
        headerView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.left.equalTo(0)
        })
        titleLabel.snp.makeConstraints({ (make) in
            make.width.height.equalToSuperview()
        })
        homeButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        })
        tableView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.left.equalTo(0)
        })
        
        // コンフィグボタンの動作
        homeButton.addTarget(self, action: #selector(ConfigViewController.onHomeButton(sender:)), for: .touchDown)
        
        // 設定用テーブル
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc internal func onHomeButton(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // セクションのタイトル
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = UILabel()
        label.backgroundColor = .black
        label.textColor = #colorLiteral(red: 0.337254902, green: 0.3333333333, blue: 0.3529411765, alpha: 1)
        label.text = sections[section] as? String
        return label
    }
    
    /*
     Cellが選択された際に呼び出される.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // チェックマークをつける
        let cell = tableView.cellForRow(at:indexPath)
        cell?.textLabel?.textColor = #colorLiteral(red: 0.9529411765, green: 0.568627451, blue: 0.1921568627, alpha: 1)
        
        // 処理
        if indexPath.section == 0 {
            print("Value: \(shutterSoundItems[indexPath.row])")
        }
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return shutterSoundItems.count
        } else {
            return 0
        }
    }
    
    // リストのアイテム
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.09019607843, alpha: 1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.textColor = UIColor.white
        cell.accessoryType = .none
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(shutterSoundItems[indexPath.row])"
        }
        
        return cell
    }
}


