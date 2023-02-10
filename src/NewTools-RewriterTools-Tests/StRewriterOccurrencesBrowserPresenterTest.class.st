"
An OccurrencesBrowserPresenterTest is a test class for testing the behavior of OccurrencesBrowserPresenter
"
Class {
	#name : #StRewriterOccurrencesBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'occurrencesBrowserPresenter'
	],
	#category : #'NewTools-RewriterTools-Tests-OcurrencesBrowser'
}

{ #category : #running }
StRewriterOccurrencesBrowserPresenterTest >> setUp [

	super setUp.
	occurrencesBrowserPresenter := StRewriterOccurrencesBrowserPresenter new
]

{ #category : #tests }
StRewriterOccurrencesBrowserPresenterTest >> testCritiques [

	| presenter |
	presenter := StRewriterOccurrencesBrowserPresenter critiques: #(  ).
	self assert: (presenter isKindOf: SpPresenter)
]

{ #category : #tests }
StRewriterOccurrencesBrowserPresenterTest >> testTitle [

	self deny: StRewriterOccurrencesBrowserPresenter title equals: 'Untitled window'
]
