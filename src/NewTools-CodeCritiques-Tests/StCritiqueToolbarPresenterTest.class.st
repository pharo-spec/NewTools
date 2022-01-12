"
A StCritiqueToolbarPresenterTest is a test class for testing the behaivor of StCritiqueToolbarPresenter
"
Class {
	#name : #StCritiqueToolbarPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'critiqueToolbar'
	],
	#category : #'NewTools-CodeCritiques-Tests'
}

{ #category : #running }
StCritiqueToolbarPresenterTest >> setUp [

	super setUp.
	critiqueToolbar := StCritiqueToolbarPresenter new.
]

{ #category : #initialization }
StCritiqueToolbarPresenterTest >> testInitialize [

	self assert: critiqueToolbar critiqueHolder value isNil.
	self assert: critiqueToolbar ruleHolder value isNil
]

{ #category : #initialization }
StCritiqueToolbarPresenterTest >> testOpen [

	| window |
	window := StCritiqueToolbarPresenter open.
	self assert: window isBuilt.
	window close
]
