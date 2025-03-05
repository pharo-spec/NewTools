"
I'm a new transcript. 

My existence is to be able to remove the global variable Transcript from the system dictionary.
I'm raising an announcement so that my visual representant can update themselves.

I'm based on a circular list.

"
Class {
	#name : 'NewThreadSafeTranscript',
	#superclass : 'Model',
	#instVars : [
		'mutex',
		'recordings',
		'index',
		'maxEntry'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : 'NewTools-Transcript',
	#package : 'NewTools-Transcript'
}

{ #category : 'declare' }
NewThreadSafeTranscript class >> install [

	self installThreadSafeAsTranscript
]

{ #category : 'declare' }
NewThreadSafeTranscript class >> installThreadSafeAsTranscript [
	<script>

	Smalltalk globals at: #Transcript put: self uniqueInstance
]

{ #category : 'declare' }
NewThreadSafeTranscript class >> reset [
	<script>

	UniqueInstance := nil
]

{ #category : 'icons' }
NewThreadSafeTranscript class >> taskbarIconName [
	"Answer the icon for the receiver in a task bar."

	^#transcript
]

{ #category : 'declare' }
NewThreadSafeTranscript class >> uniqueInstance [
	<script>

	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> << anObject [
	"Write anObject to the receiver, dispatching using #putOn:
	This is a shortcut for both nextPut: and nextPutAll: since anObject can be both
	the element type of the receiver as well as a collection of those elements.
	No further conversions of anObject are applied.
	Return self to accomodate chaining."

 	anObject putOn: self
]

{ #category : 'initialization' }
NewThreadSafeTranscript >> allocateRecodings: size [

	recordings := Array new: size
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> clear [

	mutex critical: [
		recordings := OrderedCollection new.
		index := 0.
		SystemAnnouncer uniqueInstance announce: NewEntryToTranscript new  ]
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> close [
	"Close the receiver, indicating it is not longer needed"
]

{ #category : 'protected low level' }
NewThreadSafeTranscript >> contents [ 
	"probably super inefficient again... "
	
	^ String streamContents: [ :s |
		1 to: index do: [ :i | s << (recordings at: i )] ] 
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> cr [
	"Output a cr on the receiver, buffered and not yet shown"

	self nextPut: Character cr
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> crShow: anObject [
	"Output anObject asString on the receiver preceded by a cr and show the output"

	self critical: [ self cr; show: anObject ]
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> critical: block [
	"Execute block making sure only one thread accesses the receiver"

	^ mutex critical: block
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> endEntry [
	"Show the currently buffered output"
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> flush [
	
	
]

{ #category : 'testing' }
NewThreadSafeTranscript >> hasBindingOf: aString [
	^ false
]

{ #category : 'initialization' }
NewThreadSafeTranscript >> initialize [

	super initialize.
	mutex := Mutex new.
	maxEntry := 5000.
	index := 0.
	self allocateRecodings: maxEntry
	
]

{ #category : 'initialization' }
NewThreadSafeTranscript >> maxEntry: aNumber [

	maxEntry := aNumber.
	self allocateRecodings: maxEntry.
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> nextPut: aCharacter [

	mutex critical: [
		self rawNextPut: aCharacter ].
	^ aCharacter

]

{ #category : 'streaming' }
NewThreadSafeTranscript >> nextPutAll: value [
	"Ineffient way...."

	self critical: [ value do: [ :each | self rawNextPut: each  ] ].
	^ value
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> rawNextPut: aCharacter [

	
		index := index >= maxEntry
						ifTrue: [ 1 ]
			         ifFalse: [ index + 1 ].
		recordings at: index put: aCharacter.
		SystemAnnouncer uniqueInstance announce: NewEntryToTranscript new.
	
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> reset [

	self clear
]

{ #category : 'updating' }
NewThreadSafeTranscript >> shoutAboutToStyle: aPluggableShoutMorphOrView [
	^ false
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> show: anObject [
	"Output anObject asString on the receiver and show the output"

	self critical: [ self << anObject  ]
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> space [
	"Output a space on the receiver, buffered and not yet shown"

	self nextPut: Character space
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> tab [
	"Output a tab on the receiver, buffered and not yet shown"

	self nextPut: Character tab
]
