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

	SessionLog := OrderedCollection new.
]

{ #category : 'class initialization' }
StSettingsTracker class >> reset [
	<script>
	
	SessionLog := nil
]

{ #category : 'initialization' }
StSettingsTracker class >> sessionLog [

	^ SessionLog
		ifNil: [ 
			self initialize.
			SessionLog ]
]

{ #category : 'initialization' }
StSettingsTracker >> codeSupportAnnouncer [

	^ self class codeSupportAnnouncer
]

{ #category : 'initialization' }
StSettingsTracker >> initialize [ 
	"Subscribe settings to register their changes"

	super initialize.
	self codeSupportAnnouncer weak
		when: SettingUpdated
		send: #settingUpdated:
		to: self

]

{ #category : 'initialization' }
StSettingsTracker >> sessionLog [

	^ self class sessionLog
]

{ #category : 'initialization' }
StSettingsTracker >> settingUpdated: aSetting [

	self sessionLog add: aSetting
]
