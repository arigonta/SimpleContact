//
//  Contact.swift
//  Simple Contact
//
//  Created by Ari Gonta on 23/04/20.
//  Copyright © 2020 Ari Gonta. All rights reserved.
//

import Foundation

struct ContactReponse: Codable {
    let message: String?
    let data: [Contact]
}

struct Contact: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let age: Int?
    let photo: URL?
    
    init(id: String?, firstName: String?, lastName: String?, age:Int?, photo:URL?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.photo = photo
    }
}
