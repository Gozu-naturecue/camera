//
//  ConfigViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/25.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class ConfigViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Tableで使用する配列を設定する
    private let items: NSArray = ["シャッター音", "シャッター画面"]
    
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
        let table = UITableView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableViewStyle(rawValue: 1)!)
        table.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.09019607843, alpha: 1)
        table.separatorInset = UIEdgeInsets.zero
        table.separatorColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(homeButton)
        headerView.layer.addSublayer(borderUnderHeader)
        
        
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
            //            make.top.equalTo(headerView.snp.bottom)
            make.top.equalToSuperview().offset(-5)
            make.bottom.left.equalTo(0)
        })
        
        // Cell名の登録をおこなう.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // DataSourceを自身に設定する.
        tableView.dataSource = self
        
        // Delegateを自身に設定する.
        tableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     Cellが選択された際に呼び出される
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(items[indexPath.row])")

        let nextViewController: SuperViewController;
        if indexPath.row == 0 {
            nextViewController = SoundConfigViewController()
        } else {
            nextViewController = ShutterConfigViewController()
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    /*
     Cellの総数を返す.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /*
     Cellに値を設定する
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .black
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.textColor = UIColor.white
        cell.accessoryType = .none
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(items[indexPath.row])"
        
        return cell
    }
    
}
