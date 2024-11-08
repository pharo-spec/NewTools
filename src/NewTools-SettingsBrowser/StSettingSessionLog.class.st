Class {
	#name : 'StSettingSessionLog',
	#superclass : 'Object',
	#instVars : [
		'baseDirectory',
		'fileName',
		'creationTime',
		'fileReference',
		'flushContents',
		'mutex',
		'flushAction',
		'contentReceived',
		'flushProcess',
		'timeToWait',
		'versionLog',
		'modificationTime'
	],
	#category : 'NewTools-SettingsBrowser-Logging',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Logging'
}

{ #category : 'instance creation' }
StSettingSessionLog class >> fromReference: aFileReference [

	^ self new fromReference: aFileReference
]

{ #category : 'accessing' }
StSettingSessionLog >> baseDirectory [

	^ baseDirectory ifNil:[ StSettingsTracker cacheDirectory ]
]

{ #category : 'accessing' }
StSettingSessionLog >> baseDirectory: anObject [

	baseDirectory := anObject
]

{ #category : 'private' }
StSettingSessionLog >> basicContents: aString [ 
	
	flushContents := aString
]

{ #category : 'accessing - versions' }
StSettingSessionLog >> changedSettings [
	"Answer a <Collection> of <StSettingSessionLogEntry>"

	^ Array streamContents: [ :stream | 
		self versionLog entriesDo: [ :anEntry | 
			stream nextPut: anEntry ] ]
]

{ #category : 'accessing' }
StSettingSessionLog >> contentReceived [

	^ contentReceived
]

{ #category : 'accessing' }
StSettingSessionLog >> contentReceived: anObject [

	contentReceived := anObject
]

{ #category : 'accessing' }
StSettingSessionLog >> contents [

	^ self fileReference 
		ifExists: [ :ref | ref contents ]
		ifAbsent: [ '' ]
]

{ #category : 'accessing' }
StSettingSessionLog >> contents: aString [

	aString asString trimmed ifEmpty: [ ^ self ].
	mutex critical: [
		self basicContents: aString.
		contentReceived := true.
		self spawnFlushProcess ]
]

{ #category : 'accessing' }
StSettingSessionLog >> creationTime [

	^ creationTime
]

{ #category : 'accessing' }
StSettingSessionLog >> creationTime: anObject [

	creationTime := anObject
]

{ #category : 'accessing' }
StSettingSessionLog >> creationTimeForFileName [

	^ (self creationTime asString 
		copyReplaceAll: ':' with: '-') 
		copyReplaceAll: '.' with: '-'
]

{ #category : 'accessing' }
StSettingSessionLog >> fileName [

	^ fileName ifNil: [ fileName := self creationTimeForFileName ]
]

{ #category : 'accessing' }
StSettingSessionLog >> fileName: anObject [

	fileName := anObject
]

{ #category : 'accessing' }
StSettingSessionLog >> fileReference [

	^ (self baseDirectory / self fileName) withExtension: StSettingsTracker settingExtension
]

{ #category : 'accessing' }
StSettingSessionLog >> fileReference: anObject [

	fileReference := anObject
]

{ #category : 'accessing' }
StSettingSessionLog >> flush [

	mutex critical: [ 
		flushContents ifNil: [ ^ self ].
		self fileReference parent ensureCreateDirectory.
		self fileReference 
			ensureDelete;
			writeStreamDo: [ :stream |
				stream << flushContents ].
		flushContents := nil.
		self storeChangedSetting.
		self touch.
		flushAction ifNotNil: [ 
			flushAction value ] ]
]

{ #category : 'accessing' }
StSettingSessionLog >> flushAction [

	^ flushAction
]

{ #category : 'accessing' }
StSettingSessionLog >> flushAction: anObject [

	flushAction := anObject
]

{ #category : 'accessing' }
StSettingSessionLog >> flushContents [

	^ flushContents
]

{ #category : 'accessing' }
StSettingSessionLog >> flushProcess [

	^ flushProcess
]

{ #category : 'accessing' }
StSettingSessionLog >> flushProcess: anObject [

	flushProcess := anObject
]

{ #category : 'instance creation' }
StSettingSessionLog >> fromReference: aFileReference [

	aFileReference parent = self baseDirectory 
		ifFalse: [ self baseDirectory: aFileReference parent ].
	fileName := aFileReference basenameWithoutExtension.
	creationTime := aFileReference creationTime
]

{ #category : 'initialization' }
StSettingSessionLog >> initialize [

	super initialize.
	contentReceived := false.
	creationTime := DateAndTime now.
	timeToWait := 10 milliSeconds.
	mutex := Mutex new
]

{ #category : 'accessing' }
StSettingSessionLog >> mutex [

	^ mutex
]

{ #category : 'accessing' }
StSettingSessionLog >> mutex: anObject [

	mutex := anObject
]

{ #category : 'accessing' }
StSettingSessionLog >> spawnFlushProcess [

	(flushProcess isNotNil 
		and: [ flushProcess isTerminated not ])
		ifTrue: [ ^ self ].
		
	flushProcess := [
 		[ contentReceived ] whileTrue: [
			contentReceived := false.
			self timeToWait wait ].
		self flush.
		flushProcess := nil.
		"in case I need to restart"
		contentReceived ifTrue: [ self spawnFlushProcess ].
	] fork
]

{ #category : 'accessing - versions' }
StSettingSessionLog >> storeChangedSetting [
	| entry |

	"store new version"
	entry := OmEntry content: self contents.
	entry tags at: #timestamp put: DateAndTime now.
	self versionLog newEntry: entry
	
]

{ #category : 'accessing' }
StSettingSessionLog >> timeToWait [

	^ timeToWait
]

{ #category : 'accessing' }
StSettingSessionLog >> timeToWait: aDuration [

	timeToWait := aDuration
]

{ #category : 'accessing' }
StSettingSessionLog >> touch [

	modificationTime := DateAndTime now
]

{ #category : 'accessing - versions' }
StSettingSessionLog >> versionLog [
	
	^ versionLog ifNil: [ 
		versionLog := OmFileStore fromFile: (self fileReference withExtension: 'ombu') ]
]
