//
//  ListModel.swift
//  Buddi
//
//  Created by Karl Brycz on 12/15/23.
//

import Foundation

struct Buddi: Identifiable, Codable {
    var id = UUID()
    var name: String
    var groups : [Group]
}

struct Group : Identifiable, Codable {
    var id = UUID()
    var updatedDate: Date
    var title: String
    var items : [Item]
}

struct Item : Identifiable, Codable, Hashable {
    var id = UUID()
    var text: String
}
