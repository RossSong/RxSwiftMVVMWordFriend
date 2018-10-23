//
//  ViewController.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 23..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    var searchViewModel:SearchViewModel?
    let disposeBag = DisposeBag()
    
    let throttleInterval =  0.1
    
    @IBOutlet weak var buttonList: UIButton!
    @IBOutlet weak var buttonQuiz: UIButton!
    
    @IBOutlet weak var viewContainerWord: UIView!
    @IBOutlet weak var labelWord: UILabel!
    
    @IBOutlet weak var scrollViewContainerOfImages: UIScrollView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var imageViewFirst: UIImageView!
    @IBOutlet weak var imageViewSecond: UIImageView!
    @IBOutlet weak var imageViewThird: UIImageView!
    
    @IBOutlet weak var labelMeaing: UILabel!
    
    @IBOutlet weak var constraintHeightOfFirstImageView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightOfSecondImageView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightOfThirdImageView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.searchViewModel = SearchViewModel(dicService: DaumDictionaryService(), imageService: GoogleImageSearchService(), dbManager: RealmDataManager.shared, widthOfImageView: imageViewFirst.frame.size.width)
        if let viewModel = self.searchViewModel{
            addBindsToViewModel(viewModel)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bindTextFieldSearchInput(_ viewModel: SearchViewModel) {
        self.textFieldSearch.rx.text.orEmpty.throttle(throttleInterval, scheduler: MainScheduler.instance)
            .bind(to:viewModel.searchWord).disposed(by: disposeBag)
    }
    
    func bindTextFieldSearchEndEditing() {
        self.textFieldSearch.rx.controlEvent([.editingDidEndOnExit])
            .asObservable()
            .subscribe(onNext: { _ in
                self.isEditing = false
                self.searchViewModel?.doSearchWord()
                self.labelWord.text = self.textFieldSearch.text
            })
            .disposed(by: disposeBag)
    }
    
    func setupImageView(_ imageView: UIImageView?, image: UIImage?, heightConstraint: NSLayoutConstraint?, height: CGFloat) {
        imageView?.image = image
        heightConstraint?.constant = height
    }
    
    func bindImageFirst(_ viewModel: SearchViewModel) {
        viewModel.imageFirst.asObservable().subscribe(onNext: { [weak self] (image, height) in
            self?.setupImageView(self?.imageViewFirst, image: image, heightConstraint: self?.constraintHeightOfFirstImageView, height: height)
        }).disposed(by: disposeBag)
    }
    
    func bindImageSecond(_ viewModel: SearchViewModel) {
        viewModel.imageSecond.asObservable().subscribe(onNext: { [weak self] (image, height) in
            self?.setupImageView(self?.imageViewSecond, image: image, heightConstraint: self?.constraintHeightOfSecondImageView, height: height)
        }).disposed(by: disposeBag)
    }
    
    func bindImageThird(_ viewModel: SearchViewModel) {
        viewModel.imageThird.asObservable().subscribe(onNext: { [weak self] (image, height) in
            self?.setupImageView(self?.imageViewThird, image: image, heightConstraint: self?.constraintHeightOfThirdImageView, height: height)
        }).disposed(by: disposeBag)
    }
    
    func bindMeaning(_ viewModel: SearchViewModel) {
        viewModel.meaning.asObservable().bind(to: self.labelMeaing.rx.text).disposed(by: disposeBag)
    }
    
    func bindButtonListTap(_ viewModel: SearchViewModel) {
        self.buttonList.rx.tap.bind(to: viewModel.buttonListPressed).disposed(by: disposeBag)
    }
    
    func bindButtonQuizeTap(_ viewModel: SearchViewModel) {
        self.buttonQuiz.rx.tap.bind(to: viewModel.buttonQuizPressed).disposed(by: disposeBag)
    }
    
    func bindTextFieldSearch(_ viewModel: SearchViewModel) {
        bindTextFieldSearchInput(viewModel)
        bindTextFieldSearchEndEditing()
    }
    
    func bindImageViews(_ viewModel: SearchViewModel) {
        bindImageFirst(viewModel)
        bindImageSecond(viewModel)
        bindImageThird(viewModel)
    }
    
    func bindButtonTaps(_ viewModel: SearchViewModel) {
        bindButtonListTap(viewModel)
        bindButtonQuizeTap(viewModel)
    }
    
    func bindShouldGos() {
        bindShouldGoToListViewController()
        bindShouldGoToQuizViewController()
    }

    fileprivate func addBindsToViewModel(_ viewModel: SearchViewModel) {
        bindTextFieldSearch(viewModel)
        bindImageViews(viewModel)
        bindMeaning(viewModel)
        bindButtonTaps(viewModel)
        bindShouldGos()
    }
    
    func bindShouldGoToListViewController() {
        searchViewModel?.shouldGoToListViewController.asObservable().subscribe(onNext: { [weak self] value in
            self?.performSegue(withIdentifier: "showList", sender: nil)
        }).disposed(by: disposeBag)
    }
    
    func bindShouldGoToQuizViewController() {
        searchViewModel?.shouldGoToQuizViewController.asObservable().subscribe(onNext: { [weak self] value in
            self?.performSegue(withIdentifier: "showQuiz", sender: nil)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard "showQuiz" == segue.identifier else { return }
        guard let viewController = segue.destination as? QuizViewController else { return }
        viewController.reactor = QuizViewReactor()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let viewModel = self.searchViewModel else { return false }
        return viewModel.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
}

