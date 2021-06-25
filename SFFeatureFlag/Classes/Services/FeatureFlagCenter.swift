//
//  FeatureFlagCenter.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 8.6.21.
//

import Foundation

public class FeatureFlagCenter {
    
    enum FeaturesConfigState {
        case needsRefresh
        case loading
        case loaded
    }
    
    //MARK: - Properties
    
    /// The key that will be used for getting the features config data from the remote config service. By default is set to 'featues_config'
    public var featuresConfigKey = "features_config"
    
    /// The decoding strategy that will be used when decoding the features config data
    public var featuresConfigDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
    
    private let remoteConfigService: RemoteConfigServiceProtocol
    private var featuresConfigState: FeaturesConfigState = .needsRefresh
    
    private lazy var featuresConfig: [FeatureConfig] = {
        return getFeaturesConfig()
    }()
    
    //MARK: - Private Methods
    public init(remoteConfigService: RemoteConfigServiceProtocol) {
        self.remoteConfigService = remoteConfigService
    }
    
    /// Fetches the features config data from the remote service. This method should be called only once, ideally on app launch.
    /// - Parameter forceRefresh: Use this flag if you need to force refresh the features config data
    public func fetchFeaturesConfig(forceRefresh: Bool = false) {
        if featuresConfigState != .needsRefresh && !forceRefresh {
                return
        }
        
        featuresConfigState = .loading
        
        remoteConfigService.fetchRemoteConfig { [weak self] success, error in
            guard let self = self else { return }
            
            self.featuresConfigState = .loaded
            self.featuresConfig = self.getFeaturesConfig()
        }
    }
    
    /// Evaluates whether a feature associated with a certain key should be enabled based on the features config data
    /// - Parameter featureKey: The key associated for that feature
    /// - Parameter specificConditionsDataSource: Dictionary that will be used when evaluating the specific conditions defined in the features config
    public func isFeatureEnabled(featureKey: String,
                                 specificConditionsDataSource: [String: Any] = [:]) -> Bool {
        guard let matchingFeature = featuresConfig.filter({ $0.featureName == featureKey}).first else { return true }
        guard matchingFeature.isEnabled else { return false }
        
        guard let criteria = matchingFeature.criteria else { return true }
        
        return isCriteriaSatisfied(criteria, conditionsDataSource: specificConditionsDataSource)
    }
    
    /// Determines if the passed criteria is satisfied
    /// - Parameter criteria: The criteria we want to check
    /// - Parameter conditionsDataSource: The dictionary passed by the main app that will be used for evaluating the specific conditions
    func isCriteriaSatisfied(_ criteria: Criteria, conditionsDataSource: [String: Any]) -> Bool {
        //Check the OS version
        let systemVersion = UIDevice.current.systemVersion
        if let osVersionRange = criteria.osVersion,
           !isVersionInRange(version: systemVersion, versionRange: osVersionRange) {
            return false
        }
        
        //Check the app version
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let appVersionRange = criteria.appVersion,
           !isVersionInRange(version: appVersion ?? "", versionRange: appVersionRange) {
            return false
        }
        
        //Check the active interval startDate
        if let startDate = criteria.activeInterval?.startDate?.toDate(),
           startDate.timeIntervalSince1970 > Date().timeIntervalSince1970 {
            return false
        }
        
        //Check the active interval endDate
        if let endDate = criteria.activeInterval?.endDate?.toDate(),
           endDate.timeIntervalSince1970 < Date().timeIntervalSince1970 {
            return false
        }
        
        //Check the specific conditions
        if let conditions = criteria.specificConditions, !conditions.isEmpty {
            for condition in criteria.specificConditions ?? [] {
                if !isConditionSatisfied(condition, with: conditionsDataSource[condition.key]) {
                    return false
                }
            }
        }
        
        return true
    }
    
    /// Checks whether the passed value satisfies the certain condition
    func isConditionSatisfied(_ condition: Condition, with value: Any?) -> Bool {
        guard let value = value else { return false }
        
        let validValues = condition.validValues.compactMap {$0.lowercased()}
        
        if let valueString = value as? String {
            let containedInCondition = condition.validValues.contains(valueString)
            
            return condition.inverse ? !containedInCondition : containedInCondition
        } else if let valueArray = (value as? [String])?.compactMap({$0.lowercased()}) {
            let valuesIntersection = Set(valueArray).intersection(validValues)
            
            return condition.inverse ? valuesIntersection.isEmpty : !valuesIntersection.isEmpty
        } else if let valueArray = value as? [Any] {
            let mappedArray = valueArray.compactMap {"\($0)"}
            
            return isConditionSatisfied(condition, with: mappedArray)
        }
        
        return isConditionSatisfied(condition, with: "\(value)")
    }
    
    ///Determines if the passed version is with the version range
    func isVersionInRange(version: String, versionRange: VersionRange) -> Bool {
        if let minVersion = versionRange.min, Double(minVersion) ?? 0.0 > Double(version) ?? 0.0 {
            return false
        }
        
        if let maxVersion = versionRange.max, Double(maxVersion) ?? 0.0  < Double(version) ?? 0.0 {
            return false
        }
        
        return true
    }
    
    /// Gets the featurs config data from the remote config service and decodes it to a list of FeatureConfig objects.
    func getFeaturesConfig() -> [FeatureConfig] {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = featuresConfigDecodingStrategy
        
        if let featuresConfigData = remoteConfigService.configValue(forKey: featuresConfigKey, type: Data.self) {
            let featuresConfig = try? jsonDecoder.decode([FeatureConfig].self, from: featuresConfigData)
            return featuresConfig ?? []
        }
        
        return []
    }
}

