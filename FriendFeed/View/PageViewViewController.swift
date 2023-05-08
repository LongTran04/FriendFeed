//
//  PageViewViewController.swift
//  FriendFeed
//
//  Created by Long Tran on 12/04/2023.
//

import UIKit


class PageViewViewController: UIViewController {
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var pageTableView: UITableView!
    
    var currentIndex = 0
        
    var invitationViewModel = InvitationViewModel()
    var friendViewModel = FriendViewModel()

    var listFriendData: [UserFriendModel] = []
    var listInvitationData: [UserInvitationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(setupTitleLabel), name: Notification.Name("setupPageTitleLabel"), object: nil)
        
    }
    
    static func getInstance(index: Int) -> PageViewViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PageViewViewController") as! PageViewViewController
        vc.currentIndex = index
        vc.readData(currentIndex: index)
        return vc
    }
    
    func setupView() {
        setupTitleLabel()
        pageTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        pageTableView.dataSource = self
        pageTableView.delegate = self
    }
    
    func setupData() {
        switch currentIndex {
        case 0,1:
            listInvitationData = invitationViewModel.model.data
        default:
            listFriendData = friendViewModel.model.data
        }
    }
    
    @objc func setupTitleLabel() {
        if ViewController.isExitSearchButtonHiden {
            switch currentIndex {
            case 0:
                pageTitleLabel.text = "\(listInvitationData.count) lời mời kết bạn"
            case 1:
                pageTitleLabel.text = "Gợi ý kết bạn"
            case 2:
                pageTitleLabel.text = "\(listFriendData.count) người bạn"
            default:
                pageTitleLabel.text = "\(listFriendData.count) lời mời đã gửi"
            }
        }
        else {
            switch currentIndex {
            case 0:
                pageTitleLabel.text = "Lời mời kết bạn"
            case 1:
                pageTitleLabel.text = "Gợi ý kết bạn"
            case 2:
                pageTitleLabel.text = "Bạn bè"
            default:
                pageTitleLabel.text = "Lời mời đã gửi"
            }
        }
    }
    
    func readData(currentIndex: Int) {
        switch currentIndex {
        case 0:
            invitationViewModel.readJSONFile(fileName: "invitation")
        case 1:
            invitationViewModel.readJSONFile(fileName: "suggestFriend")
        case 2:
            friendViewModel.readJSONFile(fileName: "Friend")
        default:
            friendViewModel.readJSONFile(fileName: "Sent")
        }
    }
    
    func getInvitationSearchResult(searchText: String) {
        listInvitationData = []
        if searchText == "" {
            listInvitationData = invitationViewModel.model.data
        }
        else {
            for item in invitationViewModel.model.data {
                if item.displayName.lowercased().folded.contains(searchText.lowercased().folded) {
                    listInvitationData.append(item)
                }
            }
        }
        pageTableView.reloadData()
    }
    
    func getFriendSearchResult(searchText: String) {
        listFriendData = []
        if searchText == "" {
            listFriendData = friendViewModel.model.data
        }
        else {
            for item in friendViewModel.model.data {
                if item.displayName.lowercased().folded.contains(searchText.lowercased().folded) {
                    listFriendData.append(item)
                }
            }
        }
        pageTableView.reloadData()
    }
    
    func convertInvitaionToFriendModel(model: UserInvitationModel) -> UserFriendModel {
        let current = Current(city: 0, privacy: 0)
        let address = Addresss(current: current)
        let work = FriendWork(userID: model.id, workspaceID: "", company: model.work[0].company, departments: [], departmentIDS: [], departmentID: "", department: model.work[0].department, title: model.work[0].title, roleID: "", listDepartments: [])
        let works = [work]
        let info = Info(bio: "", addresss: address, work: works)
        let friendModel = UserFriendModel(id: model.id, avatar: model.avatar, avatarThumbPattern: model.avatarThumbPattern, displayName: model.displayName, statusVerify: model.statusVerify, statusKyc: model.statusVerify, info: info, relation: 0, countMutualFriend: model.countMutualFriend, howFound: 0, createdAt: 0)
        return friendModel
    }
    
    @objc func addData(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: pageTableView)
        guard let indexPath = pageTableView.indexPathForRow(at: point) else {return}
        let invitationModel = listInvitationData[indexPath.row]
        removeItemFromInvitationData(indexPath: indexPath)
        let friendModel = convertInvitaionToFriendModel(model: invitationModel)
        let data = ["friendModel": friendModel]
        switch currentIndex {
        case 0:
            NotificationCenter.default.post(name: Notification.Name("addFriend"), object: nil, userInfo: data)
        default:
            NotificationCenter.default.post(name: Notification.Name("suggestFriend"), object: nil, userInfo: data)
        }
        pageTableView.deleteRows(at: [indexPath], with: .top)
        setupTitleLabel()
    }
    
    @objc func deleteData(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: pageTableView)
        guard let indexPath = pageTableView.indexPathForRow(at: point) else {return}
        switch currentIndex {
        case 0,1:
            removeItemFromInvitationData(indexPath: indexPath)
        default:
            removeItemFromSentData(indexPath: indexPath)
        }
        pageTableView.deleteRows(at: [indexPath], with: .top)
        setupTitleLabel()
    }
    
    func removeItemFromInvitationData(indexPath: IndexPath) {
        let id = listInvitationData[indexPath.row].id
        var index: Int = 0
        for i in 0..<invitationViewModel.model.data.count {
            if invitationViewModel.model.data[i].id == id {
                index = i
            }
        }
        listInvitationData.remove(at: indexPath.row)
        invitationViewModel.model.data.remove(at: index)
    }

    func removeItemFromSentData(indexPath: IndexPath) {
        let id = listFriendData[indexPath.row].id
        var index: Int = 0
        for i in 0..<friendViewModel.model.data.count {
            if friendViewModel.model.data[i].id == id {
                index = i
            }
        }
        listFriendData.remove(at: indexPath.row)
        friendViewModel.model.data.remove(at: index)
    }
    
}

extension PageViewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentIndex {
        case 0,1:
            return listInvitationData.count
        default:
            return listFriendData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pageTableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        switch currentIndex {
        case 0,1:
            cell.setupCell(currentIndex: currentIndex, data: listInvitationData[indexPath.row])
            cell.deleteButton.addTarget(self, action: #selector(deleteData(_ :)), for: .touchUpInside)
            cell.addFriendButton.addTarget(self, action: #selector(addData(_ :)), for: .touchUpInside)
        case 2:
            cell.setupCell(currentIndex: currentIndex, data: listFriendData[indexPath.row])
        default:
            cell.setupCell(currentIndex: currentIndex, data: listFriendData[indexPath.row])
            cell.trashButton.addTarget(self, action: #selector(deleteData(_ :)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentIndex {
        case 0,1:
            return 120
        default:
            return 85
        }
    }
    
}


