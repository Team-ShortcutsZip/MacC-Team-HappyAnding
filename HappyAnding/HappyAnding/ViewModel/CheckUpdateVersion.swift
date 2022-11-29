//
//  CheckUpdateVersion.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/29.
//

import Foundation

import FirebaseFirestore

struct Version: Codable {
    var latestVersion: String
    var minimumVersion: String
    var isNeededForceUpdate: Bool = false
    var description: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case latestVersion = "latest_version"
        case minimumVersion = "minimum_version"
        case isNeededForceUpdate, title, description
    }
}

class CheckUpdateVersion {
    
    static let share = CheckUpdateVersion()
    private let db = Firestore.firestore()
    
    func fetchVersion(completionHandler: @escaping (Version)->()) {
        
        db.collection("Version").addSnapshotListener { snapshot, error in
            guard let snapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                let decoder = JSONDecoder()
                
                do {
                    let data = diff.document.data()
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let version = try decoder.decode(Version.self, from: jsonData)
                    
                    completionHandler(version)
                    
                } catch let error {
                    print("error: \(error)")
                }
            }
        }
    }
}
