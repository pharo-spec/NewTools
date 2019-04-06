Class {
	#name : #StUnixPlatform,
	#superclass : #StPlatform,
	#category : #'NewTools-Core'
}

{ #category : #testing }
StUnixPlatform class >> isAvailable [

	^ Smalltalk os isUnix
]
