//
//  EmailHelper.swift
//  
//
//  Created by Borko Tomic on 24.2.21..
//

import Foundation
import MessageUI

extension SwiftyCore.UI {
    public class EmailHelper {
        public static func showEmailPicker(to recipients: [String], subject: String, body: String, on controller: Alertable & MFMailComposeViewControllerDelegate) {
            //guard (controller as? MFMailComposeViewControllerDelegate) != nil else { fatalError("Must comform to MFMailComposeViewControllerDelegate ") }
            let canSendNative = MFMailComposeViewController.canSendMail()
            let gmailUrl = EmailHelper.createGmailUrl(to: recipients, with: subject, and: body)
            let canSendGmail = gmailUrl != nil ? UIApplication.shared.canOpenURL(gmailUrl!) : false
            let outlookUrl = EmailHelper.createOutlookUrl(to: recipients, with: subject, and: body)
            let canSendOutlook = outlookUrl != nil ? UIApplication.shared.canOpenURL(outlookUrl!) : false
            guard canSendNative || canSendGmail || canSendOutlook else {
                controller.showOKAlert(with: "Native email, gmail, and outlook apps supported only".localized, and: "", tag: "nula")
                return
            }
            let alert = UIAlertController(title: "Select mail app".localized, message: nil, preferredStyle: .actionSheet)
            if canSendNative {
                let nativeMailHandler = { (action: UIAlertAction) in  EmailHelper.sendNativeMail(to: recipients, with: subject, and: body, on: controller as MFMailComposeViewControllerDelegate) }
                alert.addAction(UIAlertAction(title: "Mail app".localized, style: .default, handler: nativeMailHandler))
            }
            if canSendGmail {
                let gmailMailHandler = { (action: UIAlertAction) in EmailHelper.sendEmail(to: gmailUrl) }
                alert.addAction(UIAlertAction(title: "Gmail".localized, style: .default, handler: gmailMailHandler))
            }
            if canSendOutlook {
                let outlookMailHandler = { (action: UIAlertAction) in EmailHelper.sendEmail(to: outlookUrl) }
                alert.addAction(UIAlertAction(title: "Outlook".localized, style: .default, handler: outlookMailHandler))
            }
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            controller.present(alert, animated: true)
        }
        
        private static func createGmailUrl(to recipients: [String]? = nil, with subject: String, and body: String) -> URL? {
            let toEncoded = (recipients?.joined(separator: ","))?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            let googleUrlString = "googlegmail:///co?to=\(toEncoded)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
            return URL(string: googleUrlString)
        }
        
        private static func createOutlookUrl(to recipients: [String]? = nil, with subject: String, and body: String) -> URL? {
            let toEncoded = (recipients?.joined(separator: ","))?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            let outlookUrlString = "ms-outlook://compose?to=\(toEncoded)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
            return URL(string: outlookUrlString)
        }
        
        private static func sendNativeMail(to recipients: [String]? = nil, with subject: String, and body: String, on controller: MFMailComposeViewControllerDelegate) {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = controller
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            mail.setToRecipients(recipients)
            (controller as? UIViewController)?.present(mail, animated: true)
        }
        
        private static func sendEmail(to url: URL?) {
            guard let url = url else { return }
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    print("Could not open gmail/outlook app")
                }
            }
        }
    }
}
