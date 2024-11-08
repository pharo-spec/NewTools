Class {
	#name : 'StSettingsSessionLogTest',
	#superclass : 'TestCase',
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'tests' }
StSettingsSessionLogTest >> fileNameForTesting [

	^ 'test.phSetting'

]

{ #category : 'tests' }
StSettingsSessionLogTest >> fileSystemForTesting [

	^ FileSystem memory
]

{ #category : 'tests' }
StSettingsSessionLogTest >> newSettingSession [

	^ StSettingSessionLog new
		baseDirectory: self fileSystemForTesting;
		yourself
]

{ #category : 'tests' }
StSettingsSessionLogTest >> testChangedSettings [
	| v1 v2 v3 settingSession |
	
	v1 := 'v1'.
	v2 := 'v2'.
	v3 := 'v3'.
	
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
	| memory file settingEntry |
	
	memory := self fileSystemForTesting.
	file := memory / self fileNameForTesting.
	file writeStreamDo: [ :stream | stream << 'TEST'].
	
	settingEntry := StSettingSessionLog fromReference: file. 
	self assert: settingEntry fileReference equals: file.

]

{ #category : 'tests' }
StSettingsSessionLogTest >> testStoreSettingEntry [
	| v1 settingSession |
	
	v1 := 'v1'.
	settingSession := self newSettingSession.
	settingSession basicContents: v1.
	settingSession flush.
	self deny: settingSession changedSettings isEmpty.
	self assert: settingSession changedSettings first content equals: v1
]
