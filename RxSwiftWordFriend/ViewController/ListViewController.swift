//
//  ListViewController.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 24..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonEdit: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel : ListViewModel?
    
    func setupViewModel() {
        self.viewModel = ListViewModel(dbManager: RealmDataManager.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewModel()
        setupCellConfiguration()
        setupCellOnDelete()
        bind()
    }
    
    func bindTitleOfButtonEdit() {
        viewModel?.titleOfButtonEdit.asObservable().subscribe(onNext: { [weak self] value in
            self?.buttonEdit.setTitle(value, for: UIControl.State.normal)
        }).disposed(by: disposeBag)
    }
    
    func bindIsTableViewEditing() {
        viewModel?.isTableViewEditing.asObservable().subscribe(onNext: { [weak self] value in
            self?.tableView.setEditing(value, animated: true)
        }).disposed(by: disposeBag)
    }
    
    func bind() {
        bindIsTableViewEditing()
        bindTitleOfButtonEdit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func buttonBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupCellConfiguration() {
        self.viewModel?.wordList?.asObservable().bind(to:
                tableView.rx.items(cellIdentifier: "TableViewCell",
                       cellType: UITableViewCell.self)) {
                        (row, voca, cell) in
                        cell.textLabel?.text = voca.word
                        cell.detailTextLabel?.text = voca.meaning
            }
            .disposed(by: disposeBag)
    }
    
    func setupCellOnDelete() {
        self.tableView.rx.itemDeleted.subscribe(onNext: {[weak self] indexPath in
            self?.viewModel?.action.onNext(.deleteItem(index: indexPath.row))
        }).disposed(by: disposeBag)
    }
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        viewModel?.action.onNext(.buttonEditTapped)
    }
}
