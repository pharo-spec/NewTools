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

{ #category : 'initialization' }
StTestIconCellPresenter >> connectPresenters [

	buttonPresenter action: [ (executeBlock notNil and: [ self model notNil ]) ifTrue: [ executeBlock value: self model ] ]
]

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

	| classes hasAny successCount failureCount errorCount |
	classes := aMethod methodClass isAbstract
		           ifTrue: [ aMethod methodClass allSubclasses ]
		           ifFalse: [ { aMethod methodClass } ].
	successCount := (classes anySatisfy: [ :class | class methodPassed: aMethod selector ]) asBit.
	failureCount := (classes anySatisfy: [ :class | class methodFailed: aMethod selector ]) asBit.
	errorCount := (classes anySatisfy: [ :class | class methodRaisedError: aMethod selector ]) asBit.
	hasAny := successCount + failureCount + errorCount > 0.
	hasAny ifFalse: [ ^ self iconNamed: #testNotRun ].
	errorCount > 0 ifTrue: [ ^ self iconNamed: #testRed ].
	failureCount > 0 ifTrue: [ ^ self iconNamed: #testYellow ].
	^ self iconNamed: #testGreen
]

{ #category : 'initialization' }
StTestIconCellPresenter >> updatePresenter [

	| method |

	method := self model.

	method ifNil: [
			buttonPresenter icon: nil.
			buttonPresenter enabled: false.
			^ self ].

	method isTestMethod
		ifTrue: [
				buttonPresenter
					icon: (self testIconFor: method);
					enabled: true;
					help: 'Run test' ]
		ifFalse: [
				buttonPresenter
					icon: nil;
					enabled: false ]
]
