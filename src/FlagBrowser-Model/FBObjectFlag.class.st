Class {
	#name : #FBObjectFlag,
	#superclass : #FBFlag,
	#category : #'FlagBrowser-Model'
}

{ #category : #testing }
FBObjectFlag class >> matchesArgument: aFlagArgument [
	^ true
]

{ #category : #accessing }
FBObjectFlag class >> priority [
	^ 0
]
