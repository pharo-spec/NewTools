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

	self flag: #ToDo.
	"This is wrong but CI is failing without it (needs more work)"
	StSettingsTracker reset.

	tracker := StSettingsTracker new.

]

{ #category : 'tests' }
StSettingsTrackerTest >> submitPresenter: settingItem [

	settingItem open.
	settingItem setterPresenter adapter
		keyDown: $s 
		shift: false
		meta: true 
		control: false 
		option: false.
]

{ #category : 'running' }
StSettingsTrackerTest >> tearDown [

	self class codeSupportAnnouncer unsubscribe: self.
	"Clean SettingUpdated subscriptions"
	(self class codeSupportAnnouncer subscriptions subscriptionsHandling: SettingUpdated new)
		do: [ : s | self class codeSupportAnnouncer removeSubscription: s ].
	tracker sessionLog ifNotEmpty: [ : collection | collection removeLast ].
	super tearDown
]

{ #category : 'tests' }
StSettingsTrackerTest >> testBooleanSettingTracked [
	"Check if the updated setting was tracked"

	| settingItem numberOfUpdates |

	numberOfUpdates := tracker sessionLog size.
	settingItem := true asSettingPresenter: (self newMockSettingDeclaration: 1).
	settingItem value: false.
	
	self assert: tracker sessionLog size equals: numberOfUpdates + 1
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
StSettingsTrackerTest >> testNumberSettingTracked [ 
	"Check if the updated setting was tracked"

	| settingItem numberOfUpdates |

	numberOfUpdates := tracker sessionLog size.

	settingItem := 10 asSettingPresenter: (self newMockSettingDeclaration: 2).
	settingItem value: 20.
	self submitPresenter: settingItem.

	self assert: tracker sessionLog size equals: numberOfUpdates + 1.
	settingItem delete.

]

{ #category : 'tests' }
StSettingsTrackerTest >> testNumberSettingUpdated [
	"Check if the updated setting was tracked"

	| settingItem |

	self 
		when: SettingUpdated 
		do: [ : ann | 
			self assert: ann oldValue asNumber equals: 10.
			self assert: ann newValue asNumber equals: 20 ].

	settingItem := 10 asSettingPresenter: (self newMockSettingDeclaration: 2).
	settingItem value: 20.


]

{ #category : 'tests' }
StSettingsTrackerTest >> testTextSettingTracked [
	"Check if the updated setting was tracked"

	| settingItem numberOfUpdates |

	numberOfUpdates := tracker sessionLog size.

	settingItem := 'Adios' asSettingPresenter: (self newMockSettingDeclaration: 3).
	settingItem value: 'Hola'.
	self submitPresenter: settingItem.

	self assert: tracker sessionLog size equals: numberOfUpdates + 1.
	settingItem delete.
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

	settingItem := 'Adios' asSettingPresenter: (self newMockSettingDeclaration: 3).
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

	self class codeSupportAnnouncer weak
		when: anAnnouncement
		do: [ :ann | aBlock cull: ann ]
		for: self
]
