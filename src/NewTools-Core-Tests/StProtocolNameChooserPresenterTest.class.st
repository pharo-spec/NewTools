"
A StProtocolNameChooserPresenterTest is a test class for testing the behavior of StProtocolNameChooserPresenter
"
Class {
	#name : 'StProtocolNameChooserPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'NewTools-Core-Tests-ProtocolChooser',
	#package : 'NewTools-Core-Tests',
	#tag : 'ProtocolChooser'
}

{ #category : 'running' }
StProtocolNameChooserPresenterTest >> setUp [
	super setUp.
	presenter := StProtocolNameChooserPresenter new
]

{ #category : 'tests' }
StProtocolNameChooserPresenterTest >> testCreatingProtocolThatDoesntExists [
"When creating a protocol that doesn't exist beforehand, it should create it correctly with the same name as written."
	| protocolName |

	protocolName := UUID new asString36.
	presenter concernedClass: self class.
	
	presenter protocolName: protocolName.
	presenter doAcceptFromTextInput.
	self assert: presenter selectedProtocolName equals: protocolName 

]

{ #category : 'tests' }
StProtocolNameChooserPresenterTest >> testCreatingProtocolThatExists [
	"When creating a new protocol, it should create the name written."

	| protocolName |
	protocolName := 'acc'.
	presenter concernedClass: self class.

	presenter protocolName: protocolName.
	presenter doAcceptFromTextInput.
	self assert: presenter selectedProtocolName equals: 'acc'
]

{ #category : 'tests' }
StProtocolNameChooserPresenterTest >> testSmoke [

	| window |
	[ self shouldnt: [ window := presenter open ] raise: Error ] ensure: [ window ifNotNil: [ window close ] ].

	[ self shouldnt: [ window := presenter openDialog ] raise: Error ] ensure: [ window ifNotNil: [ window close ] ].

	presenter concernedClass: self class.
	presenter protocolName: 'test'.

	[ self shouldnt: [ window := presenter open ] raise: Error ] ensure: [ window close ]
]

{ #category : 'tests' }
StProtocolNameChooserPresenterTest >> testSuggestedProtocolsAreOrderedByPriority [
	"I'm not sure how to test this without using the sae code as #protocolsToSuggest so I'm hardcoding 3 of the most used protocols in the system"

	self assert: ((presenter protocolsToSuggest first: 5) includesAll: #( accessing initialization testing ))
]

{ #category : 'tests' }
StProtocolNameChooserPresenterTest >> testSuggestedProtocolsDependOnInstanceOrClassSide [

	| protocolName classProtocolName |
	protocolName := UUID new asString36.
	classProtocolName := UUID new asString36.

	[
	self class addProtocol: protocolName.
	self class class addProtocol: classProtocolName.

	presenter concernedClass: self class.
	self assert: (presenter protocolsToSuggest includes: protocolName).
	self deny: (presenter protocolsToSuggest includes: classProtocolName).

	presenter concernedClass: self class class.
	self deny: (presenter protocolsToSuggest includes: protocolName).
	self assert: (presenter protocolsToSuggest includes: classProtocolName) ] ensure: [
		self class removeProtocol: protocolName.
		self class class removeProtocol: classProtocolName ]
]

{ #category : 'tests' }
StProtocolNameChooserPresenterTest >> testSuggestedProtocolsIncludesProtocolsOfTheImage [

	| protocolName |
	protocolName := UUID new asString36.

	self deny: (presenter protocolsToSuggest includes: protocolName).
	[
	self class addProtocol: protocolName.

	self assert: (presenter protocolsToSuggest includes: protocolName) ] ensure: [ self class removeProtocol: protocolName ]
]
