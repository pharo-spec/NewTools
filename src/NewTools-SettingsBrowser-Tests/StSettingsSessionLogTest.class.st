Class {
	#name : 'StSettingsSessionLogTest',
	#superclass : 'TestCase',
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'private' }
StSettingsSessionLogTest >> fileNameForTesting [

	^ 'test.phSetting'

]

{ #category : 'private' }
StSettingsSessionLogTest >> fileReferenceForTesting [

	^ self fileSystemForTesting / self fileNameForTesting.
]

{ #category : 'private' }
StSettingsSessionLogTest >> fileSystemForTesting [

	^ FileSystem memory
]

{ #category : 'private' }
StSettingsSessionLogTest >> newMockSetting1 [

	^ SettingUpdated
		  declaration: (self newMockSettingDeclaration: 1)
		  oldValue: false
		  newValue: true
]

{ #category : 'private' }
StSettingsSessionLogTest >> newMockSetting2 [

	^ SettingUpdated
		  declaration: (self newMockSettingDeclaration: 2)
		  oldValue: 0
		  newValue: 100
]

{ #category : 'private' }
StSettingsSessionLogTest >> newMockSetting3 [

	^ SettingUpdated
		  declaration: (self newMockSettingDeclaration: 3)
		  oldValue: 'Old Value'
		  newValue: 'New Value'
]

{ #category : 'private' }
StSettingsSessionLogTest >> newMockSetting: aMockSetting asSTON: stream [

	^ (STONWriter on: (ZnCharacterWriteStream on: stream)) 
			prettyPrint: true;
			newLine: OSPlatform current lineEnding;
			nextPut: aMockSetting

]

{ #category : 'private' }
StSettingsSessionLogTest >> newMockSettingAsSTONString: aMockSetting [

	^ (ByteArray streamContents: [ :stream | 
			self 
				newMockSetting: aMockSetting
				asSTON: stream ]) asString

]

{ #category : 'private' }
StSettingsSessionLogTest >> newMockSettingDeclaration: id [

	^ SettingDeclaration new 
			name: 'MockSettingDeclaration' , id asString;
			target: self;
			selector: #mockDefault;
			default: true
]

{ #category : 'private' }
StSettingsSessionLogTest >> newSettingSession [

	^ StSettingSessionLog new
		baseDirectory: self fileSystemForTesting;
		yourself
]

{ #category : 'tests' }
StSettingsSessionLogTest >> testChangedSettings [
	| v1 v2 v3 settingSession |
	
	v1 := self newMockSettingAsSTONString: self newMockSetting1.
	v2 := self newMockSettingAsSTONString: self newMockSetting2.
	v3 := self newMockSettingAsSTONString: self newMockSetting3.
	
	settingSession := self newSettingSession.
	
	settingSession basicContents: v1.
	settingSession flush.
	
	settingSession basicContents: v2.
	settingSession flush.
	
	settingSession basicContents: v3.
	settingSession flush.
	
	self assert: settingSession changedSettings size equals: 3.
	self assert: settingSession changedSettings first content equals: v1.
	self assert: settingSession changedSettings second content equals: v2.	
	self assert: settingSession changedSettings third content equals: v3

]

{ #category : 'tests' }
StSettingsSessionLogTest >> testFlush [
	| session |
	
	session := self newSettingSession.
	session basicContents: 'test'.

	self assert: session contents isEmpty.
	
	session flush.
	
	self assert: session contents equals: 'test'
		

	
]

{ #category : 'tests' }
StSettingsSessionLogTest >> testFromReference [
	| file settingEntry |
	
	file := self fileReferenceForTesting.
	file writeStreamDo: [ :stream | stream << 'TEST'].
	
	settingEntry := StSettingSessionLog fromReference: file. 
	self assert: settingEntry fileReference equals: file.

]

{ #category : 'tests' }
StSettingsSessionLogTest >> testStoreSettingEntry [
	| v1 settingSession |
	
	v1 := self newMockSettingAsSTONString: self newMockSetting1.
	settingSession := self newSettingSession.
	settingSession basicContents: v1.
	settingSession flush.

	self deny: settingSession changedSettings isEmpty.
	self assert: settingSession changedSettings first content equals: v1
]
