"
Run the test case selected from a message browser list
"
Class {
	#name : 'StRunMethodTestCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'default' }
StRunMethodTestCommand class >> defaultName [

	^ 'Run test'
]

{ #category : 'accessing' }
StRunMethodTestCommand class >> defaultShortcut [

	^ $t actionModifier
]

{ #category : 'testing' }
StRunMethodTestCommand >> canBeExecuted [

	| method |
	method := context selectedMethod.
	method ifNil: [ ^ false ].
	^ method selector isTestSelector and: [ method isInstanceSide ]
]

{ #category : 'executing' }
StRunMethodTestCommand >> execute [

	| method selector testClasses suite result |
	method := self context selectedMethod.
	selector := method selector.
	testClasses := method methodClass isAbstract
		               ifTrue: [ method methodClass allSubclasses ]
		               ifFalse: [ { method methodClass } ].
	suite := TestSuite named: selector.
	testClasses do: [ :concreteClass | suite addTest: (concreteClass selector: selector) ].
	result := suite run.
	result updateResultsInHistory.
	self context application inform: result printString
]
