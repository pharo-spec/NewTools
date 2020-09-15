"
Description
--------------------

I am a mock used by FlagBrowser tests.
"
Class {
	#name : #FBMock,
	#superclass : #Object,
	#category : #'NewTools-FlagBrowser-Tests-Mocks'
}

{ #category : #comparing }
FBMock >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]

{ #category : #running }
FBMock >> flagMethod [
	self flag: #aRandomFlagForTest
]

{ #category : #running }
FBMock >> flagMethod2 [
	self flag: #aRandomFlagForTest
]

{ #category : #'as yet unclassified' }
FBMock >> flagStringMethod [
	self flag: 'a flag for Test flagBrowser'
]

{ #category : #'as yet unclassified' }
FBMock >> tagCapitalized [
	self flag: #TEST
]

{ #category : #'as yet unclassified' }
FBMock >> tagNotCapitalized [
	self flag: #test
]
