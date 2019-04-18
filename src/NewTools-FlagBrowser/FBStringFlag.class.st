"
Description
--------------------

I represent a flag which parameter is a String.
"
Class {
	#name : #FBStringFlag,
	#superclass : #FBFlag,
	#category : #'NewTools-FlagBrowser-Model'
}

{ #category : #testing }
FBStringFlag class >> matchesArgument: aFlagArgument [
	^ aFlagArgument isString
]

{ #category : #accessing }
FBStringFlag class >> priority [
	^ 10
]

{ #category : #'as yet unclassified' }
FBStringFlag class >> title [
	^ 'String flags'
]

{ #category : #update }
FBStringFlag >> insensitiveParameter [
	self parameter: self parameter asLowercase capitalized
]
