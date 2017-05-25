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
    
    var arrayImageViews : [UIImageView]!
    var arrayImageViewHeightConstraints : [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupArrayImageViewsAndConstraints()
        
        self.searchViewModel = SearchViewModel(dicService: DaumDictionaryService(), imageService: GoogleImageSearchService(), dbManager: RealmDataManager.shared)
        if let viewModel = self.searchViewModel{
            addBindsToViewModel(viewModel)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupArrayImageViewsAndConstraints() {
        self.arrayImageViews = [self.imageViewFirst, self.imageViewSecond, self.imageViewThird]
        self.arrayImageViewHeightConstraints = [self.constraintHeightOfFirstImageView, self.constraintHeightOfSecondImageView, self.constraintHeightOfThirdImageView]
    }
    
    fileprivate func addBindsToViewModel(_ viewModel: SearchViewModel) {
        self.textFieldSearch.rx.text.orEmpty.throttle(throttleInterval, scheduler: MainScheduler.instance)
        .bind(to:viewModel.searchWord).addDisposableTo(disposeBag)
//        viewModel.imageFirst.asObservable().bind(to: self.imageViewFirst.rx.image).addDisposableTo(disposeBag)
//        viewModel.imageSecond.asObservable().bind(to: self.imageViewSecond.rx.image).addDisposableTo(disposeBag)
//        viewModel.imageThird.asObservable().bind(to: self.imageViewThird.rx.image).addDisposableTo(disposeBag)
        viewModel.imageFirst.asObservable().subscribe(onNext: { [unowned self] image in
            self.imageSizeFit(0,image: image)
        }).addDisposableTo(disposeBag)
        
        viewModel.imageSecond.asObservable().subscribe(onNext: { [unowned self] image in
            self.imageSizeFit(1,image: image)
        }).addDisposableTo(disposeBag)
        
        viewModel.imageThird.asObservable().subscribe(onNext: { [unowned self] image in
            self.imageSizeFit(2,image: image)
        }).addDisposableTo(disposeBag)
        
        
        viewModel.meaning.asObservable().bind(to: self.labelMeaing.rx.text).addDisposableTo(disposeBag)
        
        self.buttonList.rx.tap.subscribe(onNext: { [unowned self] _ in
            print("buttonList tapped")
            self.searchViewModel?.showList()
        })
            .addDisposableTo(disposeBag)
        
        self.buttonQuiz.rx.tap.subscribe(onNext: { [unowned self] _ in
            print("buttonQuiz tapped")
            self.searchViewModel?.showQuiz()
        })
            .addDisposableTo(disposeBag)
        
        self.textFieldSearch.rx.controlEvent([.editingDidEndOnExit])
            .asObservable()
            .subscribe(onNext: { _ in
                self.isEditing = false
                self.searchViewModel?.doSearchWord()
                self.labelWord.text = self.textFieldSearch.text
            })
            .addDisposableTo(disposeBag)
    }

    func imageSizeFit(_ index:Int, image:UIImage?) {
        guard let newImage = image else { return }
        guard self.arrayImageViews.count > index else { return }
        guard 0 != newImage.size.height else { return }
        guard 0 != newImage.size.width else { return }
        let height = newImage.size.height
        let width = newImage.size.width
        let newHeight = height/width * self.arrayImageViews[index].frame.size.width
        
        self.arrayImageViews[index].image = newImage
        self.arrayImageViewHeightConstraints[index].constant = CGFloat(newHeight);
    }

}

