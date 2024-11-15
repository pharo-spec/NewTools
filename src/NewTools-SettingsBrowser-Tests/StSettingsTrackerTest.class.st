Class {
	#name : 'StSettingsTrackerTest',
	#superclass : 'TestCase',
	#instVars : [
		'tracker',
		'numberOfAnnouncements'
	],
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'tests' }
StSettingsTrackerTest >> newSettingsTracker [

	^ StSettingsTracker new
]

{ #category : 'running' }
StSettingsTrackerTest >> setUp [

	super setUp.
	numberOfAnnouncements := 0.
	tracker := self newSettingsTracker.

]

{ #category : 'tests' }
StSettingsTrackerTest >> testSettingUpdated [
	"Check if the updated setting was tracked"

	"Simulate a setting change"


	self when: SettingUpdated do: [ : ann |
		self assert: (tracker changedSettings includes: ann) ]
	

]

{ #category : 'accessing' }
StSettingsTrackerTest >> tracker [

	^ tracker
]

{ #category : 'accessing' }
StSettingsTrackerTest >> tracker: anObject [

	tracker := anObject
]

{ #category : 'tests' }
StSettingsTrackerTest >> when: anAnnouncement do: aBlock [

	self class codeChangeAnnouncer
		when: anAnnouncement
		do: [ :ann |
			numberOfAnnouncements := numberOfAnnouncements + 1.
			aBlock cull: ann ]
		for: self
]
