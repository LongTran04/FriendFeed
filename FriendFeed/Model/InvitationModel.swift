//
//  FriendFeedModel2.swift
//  FriendFeed
//
//  Created by Long Tran on 18/04/2023.
//

import Foundation

struct InvitationModel: Codable {
    var data: [UserInvitationModel]
}

struct UserInvitationModel: Codable {
    let id: Int
    let displayName: String
    let type: Int
    let avatar: String
    let work: [InvitationWork]
    let coverThumbPattern, avatarThumbPattern: String
    let statusVerify, countMutualFriend: Int
    let source: String
    let score: Int

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case type, avatar, work
        case coverThumbPattern = "cover_thumb_pattern"
        case avatarThumbPattern = "avatar_thumb_pattern"
        case statusVerify = "status_verify"
        case countMutualFriend = "count_mutual_friend"
        case source, score
    }
}

struct InvitationWork: Codable {
    let company: String
    let department, title: String
}

