enum IISWebFarmExitCode {
    Success                          = 0

    # Logging
    LoggingInitializationFailure     = 10
    LogRetentionFailure              = 11
    JsonLoggingFailure               = 12
    
    # Configuration
    SettingsValidationFailure        = 20
    ConfigurationImportFailure       = 21

    # Health
    HealthProbeFailure               = 30

    # Notifications
    NotificationFailure              = 40

    # DNS
    DnsFailure                       = 50

    # HTTPS
    HttpsFailure                     = 60

    # IIS Validation
    WebsiteValidationFailure         = 70
    ApplicationPoolValidationFailure = 80

    # Web Deploy
    WebDeployFailure                 = 90

    # Unexpected
    UnexpectedError                  = 99
} #enum IISWebFarmExitCode