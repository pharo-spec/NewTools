"
A StResetWindowPresenterTest is a test class for testing the behaivor of StResetWindowPresenter
"
Class {
	#name : #StResetWindowPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'resetWindow'
	],
	#category : #'NewTools-CodeCritiques-Tests'
}

{ #category : #running }
StResetWindowPresenterTest >> setUp [

	super setUp.
	resetWindow := StResetWindowPresenter new
]

{ #category : #tests }
StResetWindowPresenterTest >> testInitializePresenters [
self
		assert: resetWindow resetModel class
		equals: SpButtonPresenter.
	self
		assert: resetWindow currentConfigurationModel class
		equals: SpButtonPresenter.
	
]

{ #category : #tests }
StResetWindowPresenterTest >> testOpen [

	| resetPresenter |
 	resetPresenter := StResetWindowPresenter open.
 	self assert: resetPresenter isBuilt.
 	resetPresenter close
]

{ #category : #tests }
StResetWindowPresenterTest >> testOpenPackagesChooser [

	| applier |
	applier := resetWindow openPackagesChooser.
	self assert: applier isBuilt.
	applier window close
]
