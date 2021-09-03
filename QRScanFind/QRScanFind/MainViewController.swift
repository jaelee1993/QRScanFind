//
//  MainViewController.swift
//  QRScanFind
//
//  Created by Jae Lee on 8/28/21.
//

import UIKit



class MainViewController: UIViewController {
    var cameraView:UIView!
    var tableView:UITableView!
    
    var dbService = DBService()
    
    var highlightedRow:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QR Code Finder"
        view.backgroundColor = .systemBackground
        setup()
    }
    
    
    func setup() {
        setupNavigation()
        setupCameraView()
        setupTableView()
    }
    
    func setupNavigation() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "qrcode"), style: .plain, target: self, action: #selector(addQRCodeButtonHit))
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    @objc func addQRCodeButtonHit() {
        
        let alert = UIAlertController(title: "New QR Code",
                                      message: "Add a new code",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                  let code = textField.text else {
                return
            }
            
            if !self.dbService.doesCodeIdExist(id: code) {
                self.dbService.saveCode(id: code)
                self.tableView.reloadData()
            } else {
                _ = self.launchTimedModal(text: "Code exists already", duration: 1.5) {}
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { (textField:UITextField) in
            textField.keyboardType = .alphabet
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    
    func setupCameraView() {
        cameraView = UIView()
        cameraView.backgroundColor = .red
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            cameraView.heightAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 1)
        ])
        
        let scannerViewController = ScannerViewController()
        scannerViewController.codeFound = { code in
            self.handleFoundCodeId(id: code)
        }
        addChild(scannerViewController)
        scannerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        cameraView.addSubview(scannerViewController.view)
        scannerViewController.view.constraintsToSuperView(cameraView)
        
        
        cameraView.layoutIfNeeded()
    }
    
    
    
    fileprivate func setupTableView() {
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,                        forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func handleFoundCodeId(id:String) {
        if let index = dbService.findCodeId(id: id) {
            highlightedRow = index
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        } else {
            highlightedRow = nil
            tableView.reloadData()
            _ = launchTimedModal(text: "Code \(id)\nnot found", duration: 2.5, completion: {
                
            })
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbService.codes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let code = dbService.codes[indexPath.row]
        if let code = code.value(forKeyPath: "id") as? String {
            cell.textLabel?.text = "\(code)"
        }
        if let highlightedRow = highlightedRow {
            if indexPath.row == highlightedRow {
                cell.backgroundColor = .systemYellow
            } else {
                cell.backgroundColor = .systemBackground
            }
        } else {
            cell.backgroundColor = .systemBackground
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let code = dbService.codes[indexPath.row]
            dbService.deleteCode(object: code)
            dbService.codes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

