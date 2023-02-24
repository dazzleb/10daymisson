//
//  ViewController.swift
//  Write
//
//  Created by 시혁 on 2023/02/22.
//

import UIKit

class ViewController: UIViewController, EditProtocol {

    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var prifileLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //WriteVC 에서 입력된 값 을 저장 
    func editData(name: String, profile: String, introduce: String) {
        nickNameLabel.text = name
        prifileLabel.text = profile
        introduceLabel.text = introduce
    }
    
    @IBAction func popOverButton(_ sender: UIButton) {
        guard let WriteVC = self.storyboard?.instantiateViewController(identifier: "WriteVC") as? WriteViewController else { return }
        //위임
        WriteVC.delegate = self
        //WriteVC 요소 들에게 값 전달
        if let nickname = nickNameLabel.text,
           let profile = prifileLabel.text,
           let introduce = introduceLabel.text{
            WriteVC.nameText = nickname
            WriteVC.profileText = profile
            WriteVC.introduceText = introduce
        }
        
        present(WriteVC, animated: true)
    }
    
}

