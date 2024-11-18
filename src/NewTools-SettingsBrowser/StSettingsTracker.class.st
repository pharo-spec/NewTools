Class {
	#name : 'StSettingsTracker',
	#superclass : 'Object',
	#classVars : [
		'SessionLog'
	],
	#category : 'NewTools-SettingsBrowser-Logging',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Logging'
}

{ #category : 'class initialization' }
StSettingsTracker class >> initialize [

	SessionLog := OrderedCollection new
]

{ #category : 'accessing - versions' }
StSettingsTracker >> changedSettings [
	"Answer a <Collection> of <SettingUpdated>"

	^ self sessionLog
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
StSettingsTracker >> sessionLog [

	^ SessionLog
]

{ #category : 'initialization' }
StSettingsTracker >> settingUpdated: aSetting [

	self sessionLog add: aSetting
]
