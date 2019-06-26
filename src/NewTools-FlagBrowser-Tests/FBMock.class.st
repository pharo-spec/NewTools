"
Description
--------------------

I am a mock used by FlagBrowser tests.
"
Class {
	#name : #FBMock,
	#superclass : #Object,
	#category : #'NewTools-FlagBrowser-Tests'
}

{ #category : #comparing }
FBMock >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]

{ #category : #running }
FBMock >> flagMethod [
	self flag: #aRandomFlag
]

{ #category : #running }
FBMock >> flagMethod2 [
	self flag: #aRandomFlag2
]
