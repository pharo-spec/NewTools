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
	"Answer a <FileReference> pointing to the directory used for storing setting updates"

	^ SettingCacheDirectory ifNil: [ self defaultCacheDirectory ]
]

{ #category : 'accessing' }
StSettingsTracker class >> cacheDirectory: aFileReference [

	SettingCacheDirectory := aFileReference 
]

{ #category : 'defaults' }
StSettingsTracker class >> defaultCacheDirectory [
	"Answer a <FileReference> pointing to the default directory used for storing setting updates"

	^ (FileLocator localDirectory / 'settings-cache') ensureCreateDirectory
]

{ #category : 'class initialization' }
StSettingsTracker class >> reset [
	"Reset the receiver's setting cache directory"
	<script>
	
	SettingCacheDirectory := nil
	
]

{ #category : 'accessing' }
StSettingsTracker class >> settingExtension [

	^ 'phSetting'
]

{ #category : 'opening' }
StSettingsTracker class >> settingsKeywords [
	"Answer a <Collection> of <Symbol> representing selectors storing settings in the environment"

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
StSettingsTracker >> cacheDirectory [
	"Answer a <FileReference> pointing to the default directory used for storing setting updates"

	^ self class cacheDirectory 
]

{ #category : 'accessing - versions' }
StSettingsTracker >> cacheDirectory: aFileReference [
	"Set the receiver's cache directory to a <FileReference>"

	self class cacheDirectory: aFileReference
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
