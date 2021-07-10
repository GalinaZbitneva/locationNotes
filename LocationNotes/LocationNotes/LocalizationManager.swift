//
//  LocalizationManager.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 08.05.2021.
//

import Foundation

extension String{
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
