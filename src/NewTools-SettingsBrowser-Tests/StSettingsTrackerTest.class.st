Class {
	#name : 'StSettingsTrackerTest',
	#superclass : 'StSettingsSessionLogAbstractTest',
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
	tracker class cacheDirectory: self fileSystemForTesting.

]

{ #category : 'running' }
StSettingsTrackerTest >> tearDown [ 

	self tracker class reset.
	super tearDown.
]

{ #category : 'tests' }
StSettingsTrackerTest >> testSettingUpdated [
	"Check if the updated setting was tracked"

	| settingItem |

	self when: SettingUpdated do: [ : ann |
		self assert: (tracker changedSettings includes: ann) ].

	settingItem := true asSettingPresenter: (self newMockSettingDeclaration: 1).
	settingItem value: false.

	

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
