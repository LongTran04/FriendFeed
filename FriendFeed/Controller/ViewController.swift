//
//  ViewController.swift
//  FriendFeed
//
//  Created by Long Tran on 10/04/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var exitSearchButton: UIButton!
    @IBOutlet weak var headerCollectionView: CollectionViewHeader!
    
    let data = ["Lời mời", "Gợi ý kết bạn", "Bạn bè", "Đã gửi"]
    
    static var isExitSearchButtonHiden: Bool = true
    static var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        exitSearchButton.isHidden = true
        ViewController.isExitSearchButtonHiden = exitSearchButton.isHidden
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
    }
    
    @IBAction func tapExitSearchBtn(_ sender: Any) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        ViewController.searchText = ""
        exitSearchButton.isHidden = true
        ViewController.isExitSearchButtonHiden = exitSearchButton.isHidden
        NotificationCenter.default.post(name: Notification.Name("getSearchResult"), object: nil, userInfo: ["searchText": ViewController.searchText])
        NotificationCenter.default.post(name: Notification.Name("setupPageTitleLabel"), object: nil)
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ViewController.searchText = searchText
        NotificationCenter.default.post(name: Notification.Name("getSearchResult"), object: nil, userInfo: ["searchText": searchText])
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        exitSearchButton.isHidden = false
        ViewController.isExitSearchButtonHiden = exitSearchButton.isHidden
        NotificationCenter.default.post(name: Notification.Name("setupPageTitleLabel"), object: nil)
    }

}

extension String {
    var folded: String {
        return self.folding(options: .diacriticInsensitive, locale: nil)
                .replacingOccurrences(of: "đ", with: "d")
                .replacingOccurrences(of: "Đ", with: "D")
    }
}
