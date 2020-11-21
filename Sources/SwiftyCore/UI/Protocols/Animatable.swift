//
//  Animatable.swift
//  CommonCore
//
//  Created by Borko Tomic on 20/11/2020.
//

import Foundation

protocol Animatable {
    var animationDuration: Double { get }
    func animate(duration: Double?, block: @escaping () -> Void, completion: (() -> Void)?)
}
