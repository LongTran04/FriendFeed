//
//  PageViewController.swift
//  FriendFeed
//
//  Created by Long Tran on 11/04/2023.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var currentIndex = 0
    
    let pageInvitationVC = PageViewViewController.getInstance(index: 0)
    let pageSuggestFriendVC = PageViewViewController.getInstance(index: 1)
    let pageFriendVC = PageViewViewController.getInstance(index: 2)
    let pageSentVC = PageViewViewController.getInstance(index: 3)
    
    var pageViewControllerList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewControllerList = [pageInvitationVC, pageSuggestFriendVC, pageFriendVC, pageSentVC]
        setViewControllers([pageViewControllerList[0]], direction: .forward, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(changePageView(_:)), name: Notification.Name("tapCollectionViewHeaderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addFriend(_:)), name: Notification.Name("addFriend"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addSent(_:)), name: Notification.Name("suggestFriend"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getSearchText(_:)), name: Notification.Name("getSearchResult"), object: nil)
    }
    
    @objc func changePageView(_ notification: Notification) {
        let indexPath = notification.userInfo?["indexPath"] as! IndexPath
        let direction: UIPageViewController.NavigationDirection
        if currentIndex < indexPath.row {
            direction = .forward
        }
        else {
            direction = .reverse
        }
        setViewControllers([pageViewControllerList[indexPath.row]], direction: direction, animated: true)
        currentIndex = indexPath.row
        getSearchResuls(searchText: ViewController.searchText)
        NotificationCenter.default.post(name: Notification.Name("setupPageTitleLabel"), object: nil)
    }
    
    @objc func addFriend(_ notification: Notification) {
        let model = notification.userInfo?["friendModel"] as! UserFriendModel
        pageFriendVC.friendViewModel.model.data.insert(model, at: 0)
    }
    
    @objc func addSent(_ notification: Notification) {
        let model = notification.userInfo?["friendModel"] as! UserFriendModel
        pageSentVC.friendViewModel.model.data.insert(model, at: 0)
    }
    
    @objc func getSearchText(_ notification: Notification) {
        let searchText = notification.userInfo?["searchText"] as! String
        getSearchResuls(searchText: searchText)
    }
    
    func getSearchResuls(searchText: String) {
        switch currentIndex {
        case 0:
            pageInvitationVC.getInvitationSearchResult(searchText: searchText)
        case 1:
            pageSuggestFriendVC.getInvitationSearchResult(searchText: searchText)
        case 2:
            pageFriendVC.getFriendSearchResult(searchText: searchText)
        default:
            pageSentVC.getFriendSearchResult(searchText: searchText)
        }
    }
    
}

