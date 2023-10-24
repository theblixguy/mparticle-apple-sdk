//
//  MPSideloadedKit.swift
//  mParticle-Apple-SDK
//
//  Created by Ben Baron on 6/23/23.
//

import Foundation

@objc public class MPSideloadedKit: NSObject {
    @objc public var kitInstance: MPKitProtocol
    
    private var eventTypeFilters: [String:Any] = [:]
    private var eventNameFilters: [String:Any] = [:]
    private var eventAttributeFilters: [String:Any] = [:]
    private var messageTypeFilters: [String:Any] = [:]
    private var screenNameFilters: [String:Any] = [:]
    private var screenAttributeFilters: [String:Any] = [:]
    private var userIdentityFilters: [String:Any] = [:]
    private var userAttributeFilters: [String:Any] = [:]
    private var commerceEventAttributeFilters: [String:Any] = [:]
    private var commerceEventEntityTypeFilters: [String:Any] = [:]
    private var commerceEventAppFamilyAttributeFilters: [String:Any] = [:]
    private var attributeValueFiltering: [String:Any] = [:]
    
    // MUST also include the following keys with empty dictionaries as the values, or the SDK will crash
    private var addEventAttributeList: [String:Any] = [:]
    private var removeEventAttributeList: [String:Any] = [:]
    private var singleItemEventAttributeList: [String:Any] = [:]
    
    // Consent Filtering being handled seperately
    private var consentRegulationFilters: [String:Any] = [:]
    private var consentPurposeFilters: [String:Any] = [:]
    
    @objc public init(kitInstance: MPKitProtocol) {
        self.kitInstance = kitInstance
    }
    
    @objc public func addEventTypeFilter(eventType: MPEventType) {
        eventTypeFilters[MPIHasher.hashEventType(eventType)] = 0
    }
    
    @objc public func addEventNameFilter(eventType: MPEventType, eventName: String) {
        eventNameFilters[MPIHasher.hashEventName(eventType, eventName: eventName, isLogScreen: false)] = 0
    }
    
    @objc public func addScreenNameFilter(screenName: String) {
        eventNameFilters[MPIHasher.hashEventName(MPEventType.click, eventName: screenName, isLogScreen: true)] = 0
    }
    
    @objc public func addEventAttributeFilter(eventType: MPEventType, eventName: String, customAttributeKey: String) {
        eventAttributeFilters[MPIHasher.hashEventAttributeKey(eventType, eventName: eventName, customAttributeName: customAttributeKey, isLogScreen: false)] = 0
    }
    
    @objc public func addScreenAttributeFilter(screenName: String, customAttributeKey: String) {
        eventAttributeFilters[MPIHasher.hashEventAttributeKey(MPEventType.click, eventName: screenName, customAttributeName: customAttributeKey, isLogScreen: true)] = 0
    }
    
    @objc public func addUserIdentityFilter(userIdentity: MPUserIdentity) {
        userIdentityFilters[MPIHasher.hashUserIdentity(userIdentity)] = 0
    }
    
    @objc public func addUserAttributeFilter(userAttributeKey: String) {
        userAttributeFilters[MPIHasher.hashUserAttributeKey(userAttributeKey)] = 0
    }
    
    @objc public func addCommerceEventAttributeFilter(eventType: MPEventType, eventAttributeKey: String) {
        commerceEventAttributeFilters[MPIHasher.hashCommerceEventAttribute(eventType, key: eventAttributeKey)] = 1
    }
    
    @objc public func addCommerceEventEntityTypeFilter(commerceEventKind: MPCommerceEventKind) {
        commerceEventEntityTypeFilters[String(commerceEventKind.rawValue)] = 0
    }
    
    @objc public func addCommerceEventAppFamilyAttributeFilter(attributeKey: String) {
        commerceEventAppFamilyAttributeFilters[MPIHasher.hashString(attributeKey.lowercased())] = 1
    }
    
    // Special filter case that can only have 1 at a time unlike the others
    // If `forward` is true, ONLY matching events are forwarded, if false, any matching events are blocked
    // NOTE: This is iOS/Android only, web has a different signature
    // Attribute value filtering
    @objc public func setEventAttributeConditionalForwarding(attributeName: String, attributeValue: String, onlyForward: Bool) {
        self.attributeValueFiltering["a"] = MPIHasher.hashUserAttributeKey(attributeName)
        self.attributeValueFiltering["v"] = MPIHasher.hashUserAttributeValue(attributeValue)
        self.attributeValueFiltering["i"] = onlyForward;
    }
    
    // Please use the constants starting on line 393 of MPIConstants.h
    @objc public func addMessageTypeFilter(messageTypeConstant: String) {
        self.messageTypeFilters[messageTypeConstant] = 0
    }
    
    @objc public func getKitConfiguration() -> [String:Any] {
        var kitConfig: [String:Any] = [:]
        kitConfig["et"] = self.eventTypeFilters
        kitConfig["ec"] = self.eventNameFilters
        kitConfig["ea"] = self.eventAttributeFilters
        kitConfig["mt"] = self.messageTypeFilters
        kitConfig["svec"] = self.screenNameFilters
        kitConfig["svea"] = self.screenAttributeFilters
        kitConfig["uid"] = self.userIdentityFilters
        kitConfig["ua"] = self.userAttributeFilters
        kitConfig["cea"] = self.commerceEventAttributeFilters
        kitConfig["ent"] = self.commerceEventEntityTypeFilters
        kitConfig["afa"] = self.commerceEventAppFamilyAttributeFilters
        kitConfig["avf"] = self.attributeValueFiltering
        
        kitConfig["eaa"] = self.addEventAttributeList
        kitConfig["ear"] = self.removeEventAttributeList
        kitConfig["eas"] = self.singleItemEventAttributeList
        
        kitConfig["reg"] = self.consentRegulationFilters
        kitConfig["pur"] = self.consentPurposeFilters
        
        return kitConfig
    }
}
