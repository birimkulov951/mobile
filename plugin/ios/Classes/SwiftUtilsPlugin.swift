import Flutter
import UIKit
import Contacts

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

@available(iOS 9.0, *)
public class SwiftUtilsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mobileultra.utils", binaryMessenger: registrar.messenger())
        let instance = SwiftUtilsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
       

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getContactList") {
            result(getContacts(prefix: call.arguments as? String))
        }
    }
    
    func getContacts(prefix: String?) -> [[String:Any]]{
        let phoneQuery : Bool = prefix?.isNumber == true
        var contacts : [CNContact] = []
        var result = [[String:Any]]()

        //Create the store, keys & fetch request
        let store = CNContactStore()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey,
                    CNContactThumbnailImageDataKey] as [Any]

        let fetchRequest = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        // Set the predicate if there is a query
        if prefix != nil && !phoneQuery {
            fetchRequest.predicate = CNContact.predicateForContacts(matchingName: prefix!)
        }

        if #available(iOS 11, *) {
            if prefix != nil && phoneQuery {
                let phoneNumberPredicate = CNPhoneNumber(stringValue: prefix!)
                fetchRequest.predicate = CNContact.predicateForContacts(matching: phoneNumberPredicate)
            }
        }

        // Fetch contacts
        do{
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in

                if phoneQuery {
                    if #available(iOS 11, *) {
                        contacts.append(contact)
                    } else if prefix != nil && self.has(contact: contact, phone: prefix!){
                        contacts.append(contact)
                    }
                } else {
                    contacts.append(contact)
                }

            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return result
        }
      

        // Transform the CNContacts into dictionaries
        for contact : CNContact in contacts{
            result.append(contentsOf: contactToDictionary(contact: contact))
        }

        return result
    }
    
    
    func contactToDictionary(contact: CNContact) -> [[String:Any]]{

        var result = [[String:Any]]()
       
        
        for phone in contact.phoneNumbers{
            var m = [String:Any]()
            m["phone"] = phone.value.stringValue
            m["name"] = CNContactFormatter.string(from: contact, style: CNContactFormatterStyle.fullName)
            if contact.isKeyAvailable(CNContactThumbnailImageDataKey) {
                if let avatarData = contact.thumbnailImageData {
                    m["photo"] = FlutterStandardTypedData(bytes: avatarData)
                }
            }
            if contact.isKeyAvailable(CNContactImageDataKey) {
                if let avatarData = contact.imageData {
                    m["photo"] = FlutterStandardTypedData(bytes: avatarData)
                }
            }
            result.append(m)
        }
        

        return result
    }
    
    private func has(contact: CNContact, phone: String) -> Bool {
        if (!contact.phoneNumbers.isEmpty) {
            let phoneNumberToCompareAgainst = phone.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            for phoneNumber in contact.phoneNumbers {

                if let phoneNumberStruct = phoneNumber.value as CNPhoneNumber? {
                    let phoneNumberString = phoneNumberStruct.stringValue
                    let phoneNumberToCompare = phoneNumberString.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                    if phoneNumberToCompare == phoneNumberToCompareAgainst {
                        return true
                    }
                }
            }
        }
        return false
    }
}
