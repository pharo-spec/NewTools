"
Description
--------------------

I am a mock used by FlagBrowser tests.
"
Class {
	#name : #FBMock,
	#superclass : #Object,
	#category : #'FlagBrowser-Model-Tests'
}

{ #category : #comparing }
FBMock >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]
