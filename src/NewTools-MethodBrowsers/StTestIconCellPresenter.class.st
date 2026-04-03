"
I represent a presenter that contains an icon
"
Class {
	#name : 'StTestIconCellPresenter',
	#superclass : 'SpEasyColumnCellPresenter',
	#instVars : [
		'iconPresenter',
		'executeBlock'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'initialization' }
StTestIconCellPresenter >> connectPresenters [

	self eventHandler whenMouseDownDo: [ :anEvent | executeBlock ifNotNil: [ executeBlock value ] ]
]

{ #category : 'layout' }
StTestIconCellPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: iconPresenter;
		  yourself
]

{ #category : 'initialization' }
StTestIconCellPresenter >> initializePresenters [

	iconPresenter := self newImage
]

{ #category : 'block' }
StTestIconCellPresenter >> onExecute: aBlock [

	executeBlock := aBlock
]

{ #category : 'tests' }
StTestIconCellPresenter >> testIconFor: aMethod [

	| allCount successCount failureCount errorCount |
	allCount := 1.
	successCount := (aMethod methodClass methodPassed: aMethod selector) asBit.
	failureCount := (aMethod methodClass methodFailed: aMethod selector) asBit.
	errorCount := (aMethod methodClass methodRaisedError: aMethod selector) asBit.
	allCount = 0 ifTrue: [ ^ self iconNamed: #testNotRun ].
	allCount = successCount ifTrue: [ ^ self iconNamed: #testGreen ].
	errorCount = 0 & (failureCount > 0) ifTrue: [ ^ self iconNamed: #testYellow ].
	errorCount > 0 ifTrue: [ ^ self iconNamed: #testRed ].
	^ self iconNamed: #testNotRun
]

{ #category : 'initialization' }
StTestIconCellPresenter >> updatePresenter [

	| method |
	
	method := self model.
	(method selector isTestSelector and: [ method isInstanceSide ])
		ifTrue: [ iconPresenter image: (self testIconFor: method) ]
		ifFalse: [ iconPresenter image: nil ]
]
