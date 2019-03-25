Class {
	#name : #FBStringFlag,
	#superclass : #FBFlag,
	#category : #'FlagBrowser-Model'
}

{ #category : #testing }
FBStringFlag class >> matchesArgument: aFlagArgument [
	^ aFlagArgument isString
]

{ #category : #accessing }
FBStringFlag class >> priority [
	^ 10
]
