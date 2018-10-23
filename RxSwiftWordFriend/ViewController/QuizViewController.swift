//
//  QuizViewController.swift
//  RxSwiftWordFriend
//
//  Created by RossSong on 2017. 5. 24..
//  Copyright © 2017년 RossSong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class QuizViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelWord: UILabel!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reactor?.action.onNext(.load)
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
    
    func bindButtonBack() {
        self.buttonBack.rx.tap.subscribe(onNext: { _ in
            debugPrint("buttonBadk is tapped")
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    func bindButtonToAction(_ reactor: QuizViewReactor, index: Int, targetButton: UIButton) {
        targetButton.rx.tap.map { Reactor.Action.selectAnswer(index: index) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindButtonTitle(_ reactor: QuizViewReactor, index: Int, targetButton: UIButton) {
        reactor.state.map { $0.options[index] }
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                targetButton.setTitle(value, for: .normal)
            }).disposed(by: disposeBag)
    }
    
    func bindButton(_ reactor: QuizViewReactor, index: Int, targetButton: UIButton) {
        bindButtonToAction(reactor, index: index, targetButton: targetButton)
        bindButtonTitle(reactor, index: index, targetButton: targetButton)
    }
    
    func bindButtonLeft(_ reactor: QuizViewReactor) {
        bindButton(reactor, index: 0, targetButton: buttonLeft)
    }
    
    func bindButtonRight(_ reactor: QuizViewReactor) {
        bindButton(reactor, index: 1, targetButton: buttonRight)
    }
    
    func bindLabelWord(_ reactor: QuizViewReactor) {
        reactor.state.map { $0.word }.bind(to: labelWord.rx.text).disposed(by: disposeBag)
    }
    
    func getAlertStyle(_ right: Bool) -> UIAlertActionStyle {
        guard right else { return UIAlertActionStyle.destructive }
        return UIAlertActionStyle.default
    }
    
    func getAlertMessage(_ right: Bool) -> String {
        guard right else { return "틀렸습니다! 분발하세요!" }
        return "똑똑하시네요! 잘했습니다!"
    }
    
    func getTitleForAction(_ right: Bool) -> String {
        guard right else { return "Wrong!!" }
        return "OK"
    }
    
    func showAlert(_ right: Bool) {
        let style = getAlertStyle(right)
        let message = getAlertMessage(right)
        let titleForAction = getTitleForAction(right)
        
        let alert = UIAlertController(title: "Quiz", message:message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: titleForAction, style: style, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func bindShouldShowPopupForCongratulation(_ reactor: QuizViewReactor) {
        reactor.state.map { $0.shouldShowPopupForCongratulation }
            .filter{ true == $0 }
            .subscribe(onNext: { [weak self] value in
                self?.showAlert(true)
            }).disposed(by: disposeBag)
    }
    
    func bindShouldShowPopupForWrong(_ reactor: QuizViewReactor) {
        reactor.state.map { $0.shouldShowPopupForWrong }
            .filter{ true == $0 }
            .subscribe(onNext: {  [weak self] value in
                self?.showAlert(false)
            }).disposed(by: disposeBag)
    }
    
    func bindShouldShoPopup(_ reactor: QuizViewReactor) {
        bindShouldShowPopupForCongratulation(reactor)
        bindShouldShowPopupForWrong(reactor)
    }
    
    func bind(reactor: QuizViewReactor) {
        bindButtonBack()
        bindLabelWord(reactor)
        bindButtonLeft(reactor)
        bindButtonRight(reactor)
        bindShouldShoPopup(reactor)
    }

}
