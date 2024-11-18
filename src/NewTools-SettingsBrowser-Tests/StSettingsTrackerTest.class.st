Class {
	#name : 'StSettingsTrackerTest',
	#superclass : 'TestCase',
	#instVars : [
		'tracker'
	],
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'private' }
StSettingsTrackerTest >> newMockSetting1 [

	^ SettingUpdated
		  declaration: (self newMockSettingDeclaration: 1)
		  oldValue: false
		  newValue: true
]

{ #category : 'private' }
StSettingsTrackerTest >> newMockSetting2 [

	^ SettingUpdated
		  declaration: (self newMockSettingDeclaration: 2)
		  oldValue: 0
		  newValue: 100
]

{ #category : 'private' }
StSettingsTrackerTest >> newMockSetting3 [

	^ SettingUpdated
		  declaration: (self newMockSettingDeclaration: 3)
		  oldValue: 'Old Value'
		  newValue: 'New Value'
]

{ #category : 'private' }
StSettingsTrackerTest >> newMockSetting: aMockSetting asSTON: stream [

	^ (STONWriter on: (ZnCharacterWriteStream on: stream)) 
			prettyPrint: true;
			newLine: OSPlatform current lineEnding;
			nextPut: aMockSetting

]

{ #category : 'private' }
StSettingsTrackerTest >> newMockSettingAsSTONString: aMockSetting [

	^ (ByteArray streamContents: [ :stream | 
			self 
				newMockSetting: aMockSetting
				asSTON: stream ]) asString

]

{ #category : 'private' }
StSettingsTrackerTest >> newMockSettingDeclaration: id [
	
	| declaration |
	
	declaration := SettingDeclaration new 
			name: 'MockSettingDeclaration' , id asString;
			yourself.
	declaration 
		target: MockSettingTarget;
		selector: #default;
		default: true.
	^ declaration.
]

{ #category : 'tests' }
StSettingsTrackerTest >> newSettingsTracker [

	^ StSettingsTracker new
]

{ #category : 'running' }
StSettingsTrackerTest >> setUp [

	super setUp.
	tracker := self newSettingsTracker.


]

{ #category : 'tests' }
StSettingsTrackerTest >> testBooleanSettingUpdated [
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
		do: [ :ann | aBlock cull: ann ]
		for: self
]
