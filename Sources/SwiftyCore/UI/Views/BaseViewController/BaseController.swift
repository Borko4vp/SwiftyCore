//
//  BaseController.swift
//  CommonCore
//
//  Created by Borko Tomic on 21/11/2020.
//

import Foundation
import UIKit

protocol BaseController where Self: UIViewController  {
    //func pushViaMain(controller: BaseController)
    var interactivePopGestureRecognizerEnabled: Bool { get }
}
