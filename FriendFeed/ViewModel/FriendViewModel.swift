//
//  FriendViewModel.swift
//  FriendFeed
//
//  Created by Long Tran on 26/04/2023.
//

import Foundation

class FriendViewModel {
    var model = FriendModel(data: [])
    
    func readJSONFile(fileName: String) {
        do {
          if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),
          let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
              let decoder = JSONDecoder()
              model = try decoder.decode(FriendModel.self, from: jsonData)
          }
        } catch {
          print(error)
        }
    }
}
