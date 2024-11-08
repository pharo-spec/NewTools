Class {
	#name : 'StSettingsTracker',
	#superclass : 'Object',
	#classVars : [
		'SettingCacheDirectory'
	],
	#category : 'NewTools-SettingsBrowser-Logging',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Logging'
}

{ #category : 'accessing' }
StSettingsTracker class >> cacheDirectory [

	^ SettingCacheDirectory ifNil: [ self defaultCacheDirectory ]
]

{ #category : 'defaults' }
StSettingsTracker class >> defaultCacheDirectory [
	
	^ (FileLocator localDirectory / 'settings-cache') ensureCreateDirectory
]

{ #category : 'accessing' }
StSettingsTracker class >> settingExtension [

	^ 'phSetting'
]

{ #category : 'opening' }
StSettingsTracker class >> settingsKeywords [

	^ (Pragma allNamed: #systemsettings) collect: [: p | p method selector ]
]

{ #category : 'settings' }
StSettingsTracker class >> settingsOn: aBuilder [
	<systemsettings>

	(aBuilder setting: #settingCacheDirectory )
		parent: #pharoSystem;
		type: #Directory;
		default:  self defaultCacheDirectory;
		target: StSettingsTree;
		description: 'The path to the local Settings cache that stores all Setting updates in ' , self settingExtension ,  ' files';
		label: 'Local Setting cache directory'.
]

{ #category : 'accessing - versions' }
StSettingsTracker >> changedSettings [
	"Answer a <Collection> of <StSettingSessionLogEntry>"

	^ self storedChangedSettings flatCollect: [ : aSessionLog | aSessionLog changedSettings ]
]

{ #category : 'initialization' }
StSettingsTracker >> initialize [ 
	"Subscribe settings to register their changes"

	super initialize.
	self class codeSupportAnnouncer weak
		when: SettingUpdated
		send: #settingUpdated:
		to: self

]

{ #category : 'initialization' }
StSettingsTracker >> settingUpdated: aSetting [

	self shouldBeImplemented
]

{ #category : 'accessing - versions' }
StSettingsTracker >> storedChangedSettings [

	^ (self storedChangedSettingsFiles sorted: #modificationTime descending) 
			collect: [ :each | StSettingSessionLog fromReference: each ]
]

{ #category : 'accessing - versions' }
StSettingsTracker >> storedChangedSettingsFiles [

	^ self class cacheDirectory allChildrenMatching: '*.' , self class settingExtension
]
