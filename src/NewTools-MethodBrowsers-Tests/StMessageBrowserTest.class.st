Class {
	#name : 'StMessageBrowserTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers-Tests'
}

{ #category : 'running' }
StMessageBrowserTest >> setUp [
	super setUp.

	presenter := StMessageBrowser new.
]

{ #category : 'running' }
StMessageBrowserTest >> tearDown [ 

	presenter ifNotNil: [ presenter delete ].
	super tearDown.
]

{ #category : 'tests' }
StMessageBrowserTest >> testCanOpenBrowserOnImplementors [
	
	presenter browse: #asString implementors asImplementorsOf: #asString. 
	
	self assert: presenter messages notEmpty.
	self assert: (presenter window title beginsWith: 'Implementors of #asString [').
	self assert: presenter messages size > 30
]

{ #category : 'tests' }
StMessageBrowserTest >> testCanOpenBrowserOnSenders [
	
	presenter browse: #asString senders asSendersOf: #asString. 
	
	self assert: presenter messages notEmpty.
	self assert: (presenter window title beginsWith: 'Senders of #asString [').
	self assert: presenter messages size > 1500
]
