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

{ #category : 'running' }
StSettingsTrackerTest >> tearDown [

	self class codeSupportAnnouncer unsubscribe: self.
	super tearDown
]

{ #category : 'tests' }
StSettingsTrackerTest >> testBooleanSettingUpdated [
	"Check if the updated setting was tracked"

	| settingItem |

	self 
		when: SettingUpdated 
		do: [ : ann | 
			self assert: ann oldValue.
			self deny: ann newValue ].

	settingItem := true asSettingPresenter: (self newMockSettingDeclaration: 1).
	settingItem value: false.

]

{ #category : 'tests' }
StSettingsTrackerTest >> testNumberSettingUpdated [
	"Check if the updated setting was tracked"

	| settingItem |

	self 
		when: SettingUpdated 
		do: [ : ann | 
			self assert: ann oldValue equals: 10.
			self assert: ann newValue equals: 20 ].

	settingItem := 10 asSettingPresenter: (self newMockSettingDeclaration: 1).
	settingItem value: 20.


]

{ #category : 'tests' }
StSettingsTrackerTest >> testTextSettingUpdated [
	"Check if the updated setting was tracked"

	| settingItem |

	self 
		when: SettingUpdated 
		do: [ : ann | 
			self assert: ann oldValue equals: 'Adios'.
			self assert: ann newValue equals: 'Hola' ].

	settingItem := 'Adios' asSettingPresenter: (self newMockSettingDeclaration: 1).
	settingItem value: 'Hola'.

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

	self class codeSupportAnnouncer
		when: anAnnouncement
		do: [ :ann | aBlock cull: ann ]
		for: self
]
