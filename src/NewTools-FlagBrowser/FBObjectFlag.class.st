"
Description
--------------------

I represent a flag which parameter is an Object.
"
Class {
	#name : #FBObjectFlag,
	#superclass : #FBFlag,
	#category : #'NewTools-FlagBrowser-Model'
}

{ #category : #testing }
FBObjectFlag class >> matchesArgument: aFlagArgument [
	^ true
]

{ #category : #accessing }
FBObjectFlag class >> priority [
	^ 0
]

{ #category : #'as yet unclassified' }
FBObjectFlag class >> title [
	^ 'Object flags'
]

{ #category : #update }
FBObjectFlag >> insensitiveParameter [
	"Do nothing for objects."
]
