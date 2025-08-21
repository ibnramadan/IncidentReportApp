//
//  OtpDTO.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

struct OtpDTO: Codable {
    var token: String
    var roles: [Int]
    
    func mapToEntity() -> OtpEntity {
        return OtpEntity(token: token)
    }
}
