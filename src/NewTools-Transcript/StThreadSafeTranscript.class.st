"
I'm a new transcript. 

My existence is to be able to remove the global variable Transcript from the system dictionary.
I'm raising an announcement so that my visual representant can update themselves.

I'm based on a circular list.

"
Class {
	#name : 'StThreadSafeTranscript',
	#superclass : 'Model',
	#instVars : [
		'mutex',
		'recordings',
		'index',
		'maxEntry',
		'worker'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : 'NewTools-Transcript',
	#package : 'NewTools-Transcript'
}

{ #category : 'private - test support' }
StThreadSafeTranscript class >> createTestingInstance [
"This method SHOULD NOT be used. It is only used for testing."

	^ super new.
]

{ #category : 'declare' }
StThreadSafeTranscript class >> install [

	self installThreadSafeAsTranscript
]

{ #category : 'declare' }
StThreadSafeTranscript class >> installThreadSafeAsTranscript [
	<script>

	Smalltalk globals at: #Transcript put: self uniqueInstance
]

{ #category : 'instance creation' }
StThreadSafeTranscript class >> new [

	self error: 'You cannot create instances of this class. Use Singleton instead'
]

{ #category : 'declare' }
StThreadSafeTranscript class >> reset [
	<script>

	UniqueInstance := nil
]

{ #category : 'icons' }
StThreadSafeTranscript class >> taskbarIconName [
	"Answer the icon for the receiver in a task bar."

	^#transcript
]

{ #category : 'instance creation' }
StThreadSafeTranscript class >> uniqueInstance [
	
	<script>
	^ UniqueInstance ifNil: [
		UniqueInstance := super new ]
]

{ #category : 'streaming' }
StThreadSafeTranscript >> << anObject [
	"Write anObject to the receiver, dispatching using #putOn:
	This is a shortcut for both nextPut: and nextPutAll: since anObject can be both
	the element type of the receiver as well as a collection of those elements.
	No further conversions of anObject are applied.
	Return self to accomodate chaining."

	self critical: [  
		anObject putOn: self ]
]

{ #category : 'private - actions' }
StThreadSafeTranscript >> addEntry: aString [

	index := index >= maxEntry
		ifTrue: [ 1 ]
		ifFalse: [ index + 1 ].
	recordings at: index put: aString.
	self announce: aString
]

{ #category : 'initialization' }
StThreadSafeTranscript >> allocateRecordings: size [

	recordings := Array new: size
]

{ #category : 'private - actions' }
StThreadSafeTranscript >> announce: aString [

	self worker schedule: [
		SystemAnnouncer uniqueInstance 
			announce: (
				NewEntryToTranscript new 
				entry: aString;
				yourself ) ]
]

{ #category : 'accessing' }
StThreadSafeTranscript >> clear [

	self critical: [
		self allocateRecordings: maxEntry.
		index := 0 ]
]

{ #category : 'compatibility' }
StThreadSafeTranscript >> close [
	"Close the receiver, indicating it is not longer needed"
]

{ #category : 'accessing' }
StThreadSafeTranscript >> contents [ 
	
	^ String streamContents: [ :s |
		1 to: index do: [ :i | s << (recordings at: i ) asString ] ] 
]

{ #category : 'streaming' }
StThreadSafeTranscript >> cr [
	"Output a cr on the receiver"

	self nextPut: Character cr
]

{ #category : 'streaming' }
StThreadSafeTranscript >> crShow: anObject [

	self critical: [ self cr; show: anObject ]
]

{ #category : 'private - actions' }
StThreadSafeTranscript >> critical: block [
	"Execute block making sure only one thread accesses the receiver"
	
	^ mutex critical: block
]

{ #category : 'compatibility' }
StThreadSafeTranscript >> endEntry [
	"Show the currently buffered output"
]

{ #category : 'compatibility' }
StThreadSafeTranscript >> flush [
	
	
]

{ #category : 'testing' }
StThreadSafeTranscript >> hasBindingOf: aString [

	^ false
]

{ #category : 'initialization' }
StThreadSafeTranscript >> initialize [

	super initialize.
	mutex := Mutex new.
	maxEntry := 3000.
	index := 0.
	self allocateRecordings: maxEntry
]

{ #category : 'initialization' }
StThreadSafeTranscript >> maxEntry: aNumber [

	maxEntry := aNumber.
	self allocateRecordings: maxEntry.
]

{ #category : 'private - accessing' }
StThreadSafeTranscript >> nextPut: aCharacter [

	self critical: [
		self addEntry: aCharacter asString ].
	^ aCharacter

]

{ #category : 'private - accessing' }
StThreadSafeTranscript >> nextPutAll: value [

	self critical: [ 
		self addEntry: value asString ].
	^ value
]

{ #category : 'ui' }
StThreadSafeTranscript >> open [ 

	^ StTranscriptPresenter openOn: self
]

{ #category : 'accessing' }
StThreadSafeTranscript >> reset [

	^ self clear
]

{ #category : 'compatibility' }
StThreadSafeTranscript >> shoutAboutToStyle: aPluggableShoutMorphOrView [

	^ false
]

{ #category : 'streaming' }
StThreadSafeTranscript >> show: anObject [
	"Output anObject asString on the receiver and show the output"
	
	self critical: [  
		self << anObject ]
]

{ #category : 'streaming' }
StThreadSafeTranscript >> space [
	"Output a space on the receiver"

	self nextPut: Character space
]

{ #category : 'compatibility' }
StThreadSafeTranscript >> stepGlobal [ 
	"Do nothing this is just to be compatible with the old transcript
		Not having this method while morphic is calling you is a bad idea and you are dead."
]

{ #category : 'streaming' }
StThreadSafeTranscript >> tab [
	"Output a tab on the receiver"

	self nextPut: Character tab
]

{ #category : 'private - accessing' }
StThreadSafeTranscript >> worker [ 

	worker ifNil: [ worker := TKTWorker new start ].
	^ worker ensureIsWorking
]
