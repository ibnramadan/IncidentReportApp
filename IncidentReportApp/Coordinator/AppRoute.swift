//
//  AppRoute.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

enum AppRoute: Hashable {
    case home
    case login
    case otp(email: String)
    case dashboard
    case submitIncident
}
