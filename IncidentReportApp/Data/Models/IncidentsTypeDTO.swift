//
//  IncidentsTypeDTO.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

// MARK: - IncidentsTypeDto
struct IncidentsTypeDTO: Codable {
    let id: Int
    let arabicName, englishName: String
    let subTypes: [IncidentsTypeDTO]?
    let categoryID: Int?

    enum CodingKeys: String, CodingKey {
        case id, arabicName, englishName, subTypes
        case categoryID = "categoryId"
    }
    
    func maptoEntity() -> IncidentsTypeEntity {
        IncidentsTypeEntity(id: id, arabicName: arabicName, englishName: englishName, categoryID: categoryID)
    }
}
