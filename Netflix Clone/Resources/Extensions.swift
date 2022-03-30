//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Daffolapmac-155 on 27/03/22.
//

import Foundation

extension String{
    func capitalisedFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
