//
//  AppState.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//
import SwiftUI

enum AppStorageKey: String {
    case isOnboardingDone
}

final class AppState: ObservableObject {
    @AppStorage(AppStorageKey.isOnboardingDone.rawValue) var isOnboardingDone: Bool = false
}
