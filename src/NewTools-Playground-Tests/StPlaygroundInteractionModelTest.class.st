Class {
	#name : 'StPlaygroundInteractionModelTest',
	#superclass : 'SpCodeScriptingInteractionModelTest',
	#instVars : [
		'application'
	],
	#category : 'NewTools-Playground-Tests',
	#package : 'NewTools-Playground-Tests'
}

{ #category : 'instance creation' }
StPlaygroundInteractionModelTest >> newInteractionModel [

	^ StPlaygroundInteractionModel new
		owner: (StPlaygroundPresenter new
			application: application;
			yourself);
		yourself
]

{ #category : 'running' }
StPlaygroundInteractionModelTest >> setUp [
	super setUp.
	
	application := StPharoApplication new.
]

{ #category : 'tests' }
StPlaygroundInteractionModelTest >> testMakeBindingLocal [
	| im1 im2 binding |
	
	im1 := self newInteractionModel.
	im2 := self newInteractionModel.
	
	binding := WorkspaceVariable key: #testBinding value: 42.
	application addSharedBinding: binding.

	self assert: (application sharedBindings includesKey: #testBinding).
	self assert: (im1 hasBindingOf: #testBinding).
	self assert: (im2 hasBindingOf: #testBinding).
	
	im1 makeBindingLocal: binding.
	self deny: (application sharedBindings includesKey: #testBinding).
	self assert: (im1 hasBindingOf: #testBinding).
	self deny: (im2 hasBindingOf: #testBinding)
]

{ #category : 'tests' }
StPlaygroundInteractionModelTest >> testMakeBindingShared [
	| im1 im2 binding |
	
	im1 := self newInteractionModel.
	im2 := self newInteractionModel.
	
	binding := WorkspaceVariable key: #testBinding value: 42.

	im1 addBinding: binding.
	self deny: (application sharedBindings includesKey: #testBinding).
	self assert: (im1 hasBindingOf: #testBinding).
	self deny: (im2 hasBindingOf: #testBinding).
	
	im1 makeBindingShared: binding.
	self assert: (application sharedBindings includesKey: #testBinding).
	self assert: (im1 hasBindingOf: #testBinding).
	self assert: (im2 hasBindingOf: #testBinding)
	
]
