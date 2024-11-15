Class {
	#name : 'StSettingsSessionLogAbstractTest',
	#superclass : 'TestCase',
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'private' }
StSettingsSessionLogAbstractTest >> fileNameForTesting [

	^ 'test.phSetting'

]

{ #category : 'private' }
StSettingsSessionLogAbstractTest >> fileReferenceForTesting [

	^ self fileSystemForTesting / self fileNameForTesting.
]

{ #category : 'private' }
StSettingsSessionLogAbstractTest >> fileSystemForTesting [

	^ FileSystem memory root
]

{ #category : 'private' }
StSettingsSessionLogAbstractTest >> newMockSettingDeclaration: id [
	
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

{ #category : 'private' }
StSettingsSessionLogAbstractTest >> newSettingSession [

	^ StSettingSessionLog new
		baseDirectory: self fileSystemForTesting;
		yourself
]

{ #category : 'private' }
StSettingsSessionLogAbstractTest >> newSettingSession: aFileReference [

	^ StSettingSessionLog new
		fromReference: aFileReference;
		yourself
]
