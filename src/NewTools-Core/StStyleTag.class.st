Class {
	#name : #StStyleTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'start',
		'stop'
	],
	#category : #'NewTools-Core'
}

{ #category : #'instance creation' }
StStyleTag class >> newName: aString from: start to: stop [

	^ self basicNew 
		initializeName: aString from: start to: stop;
		yourself
]

{ #category : #visiting }
StStyleTag >> acceptTextBuffer: textBuffer [

	textBuffer 
		applyTagByName: self name asString
		start: self start - 1
		end: self stop
]

{ #category : #initialization }
StStyleTag >> initializeName: aString from: startNumber to: stopNumber [

	self initialize.
	name := aString.
	start := startNumber.
	stop := stopNumber
]

{ #category : #accessing }
StStyleTag >> name [

	^ name
]

{ #category : #printing }
StStyleTag >> printOn: aStream [ 
	
	aStream << self name << ' (' << self start asString << '-' << self stop asString << ')'
]

{ #category : #accessing }
StStyleTag >> start [

	^ start
]

{ #category : #accessing }
StStyleTag >> stop [

	^ stop
]
