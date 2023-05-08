//
//  Model.swift
//  FriendFeed
//
//  Created by Long Tran on 12/04/2023.
//

import Foundation

struct FriendModel: Codable {
    var data: [UserFriendModel]
}

struct UserFriendModel: Codable {
    let id: Int
    let avatar, avatarThumbPattern: String
    let displayName: String
    let statusVerify, statusKyc: Int
    let info: Info
    let relation, countMutualFriend, howFound, createdAt: Int

    enum CodingKeys: String, CodingKey {
        case id, avatar
        case avatarThumbPattern = "avatar_thumb_pattern"
        case displayName = "display_name"
        case statusVerify = "status_verify"
        case statusKyc = "status_kyc"
        case info, relation
        case countMutualFriend = "count_mutual_friend"
        case howFound = "how_found"
        case createdAt = "created_at"
    }
}

struct Info: Codable {
    let bio: String
    let addresss: Addresss?
    let work: [FriendWork]
}

struct Addresss: Codable {
    let current: Current
}

struct Current: Codable {
    let city: Int
    let privacy: Int?
}

struct FriendWork: Codable {
    let userID: Int
    let workspaceID, company: String
    let departments, departmentIDS: [String]?
    let departmentID, department, title, roleID: String?
    let listDepartments: [ListDepartment]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case workspaceID = "workspace_id"
        case company, departments
        case departmentIDS = "department_ids"
        case departmentID = "department_id"
        case department, title
        case roleID = "role_id"
        case listDepartments = "list_departments"
    }
}

struct ListDepartment: Codable {
    let treeID: String
    let departmentIDS, departments: [String]
    let departmentID, department: String
    let roleID, title: String?

    enum CodingKeys: String, CodingKey {
        case treeID = "tree_id"
        case departmentIDS = "department_ids"
        case departments
        case departmentID = "department_id"
        case department
        case roleID = "role_id"
        case title
    }
}


