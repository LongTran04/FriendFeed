//
//  TableViewCell.swift
//  FriendFeed
//
//  Created by Long Tran on 12/04/2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCompanyLabel: UILabel!
    @IBOutlet weak var userDepartmentLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        addFriendButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupFriendCell(data: UserFriendModel) {
        if data.avatar == "" {
            userImageView.image = UIImage(systemName: "person.circle.fill")
        }
        else {
            userImageView.load(urlString: data.avatar)
        }
        setupUserNameLabel(text: data.displayName)
        let info: Info = data.info
        if info.work.count < 1 {
            userCompanyLabel.text = ""
            userDepartmentLabel.text = ""
        }
        else {
            userCompanyLabel.text = info.work[0].company
            let department = info.work[0].department ?? ""
            userDepartmentLabel.text = department
        }
        buttonStackView.isHidden = true
    }
    
    func setupInvitationCell(data: UserInvitationModel) {
        let urlUserImageView = data.avatar
        if urlUserImageView == "" {
            userImageView.image = UIImage(systemName: "person.circle.fill")
        }
        else {
            userImageView.load(urlString: urlUserImageView)
        }
        setupUserNameLabel(text: data.displayName)
        userCompanyLabel.text = data.work[0].company
        userDepartmentLabel.text = data.work[0].department
        trashButton.isHidden = true
        chatButton.isHidden = true
    }
    
    func setupUserNameLabel(text: String) {
        if ViewController.isExitSearchButtonHiden {
            userNameLabel.highlightText(text, in: text)
        }
        else {
            if ViewController.searchText == "" {
                userNameLabel.highlightText(text, in: text)
            }
            else {
                userNameLabel.highlightSearchText(ViewController.searchText, in: text)
            }
        }
    }
    
    func setupCell<T>(currentIndex: Int, data: T) {
        switch currentIndex {
        case 0,1:
            setupInvitationCell(data: data as! UserInvitationModel)
        case 2:
            setupFriendCell(data: data as! UserFriendModel)
            trashButton.isHidden = true
        default:
            setupFriendCell(data: data as! UserFriendModel)
            chatButton.isHidden = true
        }
    }
    
    @IBAction func tapTrashButton(_ sender: UIButton) {}
    
}

var imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func load(urlString: String) {
        if let image = imageCache.object(forKey: urlString as NSString) {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UILabel {
    func highlightSearchText(_ text: String, in mainText: String) {
        let highlightAttributedString = NSMutableAttributedString(string: mainText)
        let range = (mainText.lowercased().folded as NSString).range(of: text.lowercased().folded)
        highlightAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.customColor, range: range)
        self.attributedText = highlightAttributedString
    }
    
    func highlightText(_ text: String, in mainText: String) {
        let highlightAttributedString = NSMutableAttributedString(string: mainText)
        let range = (mainText.lowercased().folded as NSString).range(of: text.lowercased().folded)
        highlightAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        self.attributedText = highlightAttributedString
    }
}

extension UIColor {
     static let customColor = UIColor(red: 0.23, green: 0.71, blue: 0.48, alpha: 1.00)
}
