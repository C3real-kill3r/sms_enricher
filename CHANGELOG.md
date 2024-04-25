## [1.0.1]

### Added
- added a capabilty for SMS retrieval by sender name, allowing filtering of SMS messages from specific senders in while app is running on the background.

## [1.0.0]

### Added
- Added functionality to request SMS read permissions from the user.
- Implemented SMS retrieval by sender name, allowing filtering of SMS messages from specific senders.

### Fixed
- Fixed the `MissingPluginException` issue by ensuring method channel functions are properly implemented in Kotlin.
- Corrected the use of the `ActivityAware` interface to ensure that activity context is correctly managed, especially during permission requests.

### Changed
- Improved error handling to provide more detailed feedback for permission and retrieval errors.


## [0.0.1]

### Added

- Initial release of the SMS Enricher plugin.
- Features:
  - User permission request for SMS access.
  - Retrieval of SMS messages based on sender or content filters.
  - On-device data enrichment including sentiment analysis and named entity recognition.
  - Secure data transmission to backend servers via HTTPS.

Please refer to this document to keep track of bug fixes, feature enhancements, and significant updates to the SMS Enricher plugin.
