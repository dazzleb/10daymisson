//
//  WriteViewController.swift
//  Write
//
//  Created by 시혁 on 2023/02/22.
//

import Foundation
import UIKit
//protocol profileTextProtocol {
//    func profileCnttextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//}
//protocol nameTextProtocol {
//    func nameCnttextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//}
protocol EditProtocol {
    func editData(name: String, profile: String, introduce: String)
}

class WriteViewController : ViewController{

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameCountLabel: UILabel!
    
    @IBOutlet weak var prifileTextField: UITextField!
    
    @IBOutlet weak var profileCountLabel: UILabel!
    
    @IBOutlet weak var introduceTextView: UITextView!
    
    @IBOutlet weak var introduceCountLabel: UILabel!
    
    @IBOutlet weak var linkStackView: UIStackView!
    
    @IBOutlet weak var webLinkTextFiedl: UITextField!
    
    @IBOutlet weak var linkContainer: UIView!
    
    @IBOutlet weak var addLinkButton: UIButton!
    
    var delegate : EditProtocol?
    
    var nameText : String?
    var profileText : String?
    var introduceText : String?
    var cnt = 0
    let textViewPlaceHolder =
    """
    다른 사람에게 나를 소개할 수 있도록 \n
    자신의 활동을 자세하게 적어주세요
    """
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        prifileTextField.delegate = self
        introduceTextView.delegate = self
        addText()
        
        introduceTextView.layer.borderWidth = 1.0
        introduceTextView.layer.borderColor = UIColor(red: 0.855, green: 0.859, blue: 0.871, alpha: 1).cgColor
        introduceTextView.layer.cornerRadius = 8
        introduceTextView.text = textViewPlaceHolder
        
        
        countSet()
        
        
    }
    
    /// ViewController 에서 보낸 데이터 집어 넣기
    func addText(){
        nameTextField.text = nameText
        prifileTextField.text = profileText
        introduceTextView.text = introduceText
    }
    @IBAction func nicknameTextFieldAct(_ sender: UITextField) {
        
    }
    
    /// 링크 추가
    /// - Parameter sender: <#sender description#>
    @IBAction func addWebLinkButton(_ sender: UIButton) {
        
        guard let weblink = webLinkTextFiedl.text else { return }
        
        if cnt < 2 && !weblink.isEmpty{
            cnt = cnt + 1
            print(#fileID, #function, #line, "\(cnt)" )
            
            lazy var trashTextField = UITextField()
            trashTextField.placeholder = "SNS 또는 홈페이지를 연결해주세요."
            trashTextField.text = "\(weblink)"
            trashTextField.font = .systemFont(ofSize: 14, weight: .regular)
            trashTextField.layer.cornerRadius = 8
            trashTextField.layer.borderWidth = 1
            trashTextField.layer.borderColor = UIColor(red: 0.855, green: 0.859, blue: 0.871, alpha: 1).cgColor
            trashTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                trashTextField.heightAnchor.constraint(equalToConstant: 40)
            ])
            //btn
            let trashButton = trashButton()
            
            // 이거를 익스텐션 시켜서 arrangedSubviews.last 로 마지막꺼 뽑아서 어쩌구 저쩌고해야함 https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=horajjan&logNo=220792520629
            lazy var trashStackView = UIStackView()
            trashStackView.axis = .horizontal
            trashStackView.spacing = 10
            trashStackView.addArrangedSubview(trashTextField)
            trashStackView.addArrangedSubview(trashButton)
            linkStackView.addArrangedSubview(trashStackView)
            
        }else{
            let noaddLabel = UILabel()
            noaddLabel.text = "웹사이트는 3개까지 추가 가능합니다."
            noaddLabel.font = .systemFont(ofSize: 14, weight: .thin)
            noaddLabel.textColor = UIColor(red: 0.892, green: 0.368, blue: 0.368, alpha: 1)
            noaddLabel.translatesAutoresizingMaskIntoConstraints = false
            addLinkButton.translatesAutoresizingMaskIntoConstraints = false
            linkContainer.addSubview(noaddLabel)
            NSLayoutConstraint.activate([
                noaddLabel.topAnchor.constraint(equalTo: addLinkButton.bottomAnchor, constant: 0),
                noaddLabel.leadingAnchor.constraint(equalTo: linkContainer.leadingAnchor, constant: 17.5),
                noaddLabel.centerXAnchor.constraint(equalTo: linkContainer.centerXAnchor)
            ])
        }
        
        
    }
    
    /// 완료 버튼 : ViewController 라벨에 text 에 데이터 넣기 , 뷰 닫기
    /// - Parameter sender: <#sender description#>
    @IBAction func completionButton(_ sender: UIButton) {
            // ViewController 라벨에 text 에 데이터 넣기
        if let name = nameTextField.text,
           let profile = prifileTextField.text,
           let introduce = introduceTextView.text
        {
            delegate?.editData(
                                   name: name,
                                   profile: profile,
                                   introduce:introduce )
        }
            // 뷰 닫기
        self.dismiss(animated: true)
                
    }
    
}
extension WriteViewController: UITextFieldDelegate {
        // 텍스트 필드에 새로운 문자를 입력하거나 삭제할때마다  이 메서드가 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        guard let nameTextFieldCnt = nameTextField.text else { return false }
        guard let profileTextFieldCnt = prifileTextField.text else { return false }
        if textField == nameTextField{
            print(#fileID, #function, #line, "name" )
            let newtLength = nameTextFieldCnt.count + string.count - range.length
            nameCountLabel.text = "\(nameTextFieldCnt.count) / 20"
            return newtLength <= maxLength
        }else if textField == prifileTextField{
            print(#fileID, #function, #line, "profile" )
            let newtLength = profileTextFieldCnt.count + string.count - range.length
            profileCountLabel.text = "\(profileTextFieldCnt.count) / 20"
            return newtLength <= maxLength
        }
        return false
        }

}
extension WriteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let maxLength = 1000
        guard let introduceTextCnt = introduceTextView.text else { return  false }
        //range    NSRange    location=0, length=40 (현재 전체길이)
        // text 현재 입력 글
        if textView == introduceTextView {
            let newtLength = introduceTextCnt.count + text.count - range.length
            introduceCountLabel.text = "\(introduceTextCnt.count) / 1000"
            return newtLength <= maxLength
        }
        return false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == textViewPlaceHolder {
                textView.text = nil
                textView.textColor = .black
            }
        }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
extension WriteViewController {
    fileprivate func trashButton() -> UIButton {
        lazy var trashButton = UIButton()
        trashButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)

        trashButton.layer.borderWidth = 1.0
        trashButton.layer.borderColor = UIColor(red: 0.855, green: 0.859, blue: 0.871, alpha: 1).cgColor
        trashButton.layer.cornerRadius = 8
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.addTarget(self, action: #selector(setBtnTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            trashButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        return trashButton
    }
    @objc func setBtnTap() {
        print(#fileID, #function, #line, "\(cnt) 지우기전" )
        cnt = cnt - 1
        //auto layout Trash 지우기
        if let lastLinkView = self.linkStackView.arrangedSubviews.last{
            self.linkStackView.removeArrangedSubview(lastLinkView)
            lastLinkView.removeFromSuperview()
        }
        print(#fileID, #function, #line, "\(cnt) 지운 후" )
     }
    
    /// 처음 열었을 때 글자의 수 를 카운트 하는 함수
    fileprivate func countSet() {
        guard let nameTextFieldCnt = nameTextField.text?.count else { return  }
        guard let profileTextFieldCnt = prifileTextField.text?.count else { return  }
        guard let introduceTextCnt = introduceTextView.text?.count else { return  }
        nameCountLabel.text = "\(nameTextFieldCnt) / 20"
        profileCountLabel.text = "\(profileTextFieldCnt) / 20"
        introduceCountLabel.text = "\(introduceTextCnt) / 1000"
    }
}
