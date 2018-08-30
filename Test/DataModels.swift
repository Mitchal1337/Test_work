//
//  DataModels.swift
//  Test
//
//  Created by GG on 28.08.2018.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation

struct LoginedUser:Decodable {
    var success:Bool
    var data:data
    var errors:[Errors?]
}
struct data:Decodable{
    var uid: Int
    var name: String
    var email: String
    var access_token: String
    var role: Int
    var status: Int
    var created_at: Int
    var update_at: Int?
}
struct Errors: Decodable {
    var message:String
}
struct GetText: Decodable {
    var data: String
}
