"
I represent a presenter that contains an icon
"
Class {
	#name : 'StTestIconCellPresenter',
	#superclass : 'SpEasyColumnCellPresenter',
	#instVars : [
		'buttonPresenter',
		'executeBlock'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'layout' }
StTestIconCellPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: buttonPresenter;
		  yourself
]

{ #category : 'initialization' }
StTestIconCellPresenter >> initializePresenters [

	buttonPresenter := self newButton
		                   addStyle: 'flat';
		                   yourself
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
	method ifNil: [
			buttonPresenter icon: nil.
			^ self ].
	(method selector isTestSelector and: [ method isInstanceSide ])
		ifTrue: [
				buttonPresenter 
					icon: (self testIconFor: method);
					action: [ executeBlock value: method ] ]
		ifFalse: [ buttonPresenter icon: nil ]
]
