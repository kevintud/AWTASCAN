//
//  Struct.swift
//  AWTAScan
//
//  Created by Kevin on 4/3/25.
//


struct DetailsLogin: Codable {
    let id: Int
    let name: String
    let username: String
    let local_church: String
    let remember_token: String?
    let created_at: String
    let updated_at: String
}

struct LoginResponse: Codable {
    let status: String
    let details: DetailsLogin
}


struct DelegateData: Codable {
    let uuid: String
    let email: String
    let fullname: String
    let registrationType: String
    let localChurch: String
    let clusterGroup: String
    let country: String
    let attendingOption: String
    let oldUuid: String

    enum CodingKeys: String, CodingKey {
        case uuid
        case email
        case fullname
        case registrationType = "registration_type"
        case localChurch = "local_church"
        case clusterGroup = "cluster_group"
        case country
        case attendingOption = "attending_option"
        case oldUuid = "old_uuid"
    }
}
