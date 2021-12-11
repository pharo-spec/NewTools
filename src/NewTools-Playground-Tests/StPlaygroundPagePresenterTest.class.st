Class {
	#name : #StPlaygroundPagePresenterTest,
	#superclass : #StPlaygroundBaseTest,
	#instVars : [
		'classFactory'
	],
	#category : #'NewTools-Playground-Tests'
}

{ #category : #private }
StPlaygroundPagePresenterTest >> classFactory [

	^ classFactory ifNil: [ classFactory := ClassFactoryForTestCase new ]
]

{ #category : #accessing }
StPlaygroundPagePresenterTest >> classToTest [

	^ StPlaygroundPagePresenter
]

{ #category : #initialization }
StPlaygroundPagePresenterTest >> initializeInstanceBeforeInitialization: aPresenter [

	aPresenter setModelBeforeInitialization: self newPage
]

{ #category : #running }
StPlaygroundPagePresenterTest >> tearDown [

	classFactory ifNotNil: [ 
		classFactory cleanUp.
		classFactory := nil ].
	super tearDown
]

{ #category : #tests }
StPlaygroundPagePresenterTest >> testAddMenuCommandsTo [
	| group commands class |

	class := self classFactory newSubclassOf: StPlaygroundMenuExtensionCommand.
	
	group := CmCommandGroup forSpec.
	presenter addMenuCommandsTo: group.
	commands := group allCommands collect: [ :each | each innerCommand class ] as: Array.	
	self assert: (commands includes: class).

]

{ #category : #tests }
StPlaygroundPagePresenterTest >> testAddToolbarCommandsTo [
	| group commands class |

	class := self classFactory newSubclassOf: StPlaygroundToolbarExtensionCommand.
	
	group := CmCommandGroup forSpec.
	presenter addToolbarCommandsTo: group.
	commands := group allCommands collect: [ :each | each innerCommand class ] as: Array.	
	self assert: (commands includes: class).

]

{ #category : #'tests - commands' }
StPlaygroundPagePresenterTest >> testDoEvaluateAllAndGo [
	| value |
	
	self openInstance.
	
	presenter contents: '42 factorial'.
	presenter whenActivatedDo: [ :selection | value := selection value ].

	presenter doEvaluateAllAndGo.
	self 
		assert: value
		equals:  1405006117752879898543142606244511569936384000000000
]

{ #category : #'tests - commands' }
StPlaygroundPagePresenterTest >> testDoEvaluateAndGo [
	| value |
	
	self openInstance.
	
	presenter contents: '42 factorial'.
	presenter whenActivatedDo: [ :selection | value := selection value ].

	presenter text selectionInterval: (1 to: 2).
	presenter doEvaluateAndGo.
	self 
		assert: value
		equals:  42.
			
	presenter text selectionInterval: (1 to: 12).
	presenter doEvaluateAndGo.
	self 
		assert: value
		equals:  1405006117752879898543142606244511569936384000000000
]

{ #category : #'tests - commands' }
StPlaygroundPagePresenterTest >> testDoEvaluateDeclareGlobal [
	| value |
	
	self deny: (Smalltalk globals includesKey: #MyGlobalForTest).
	
	self openInstance.
	
	presenter contents: 'MyGlobalForTest'.
	presenter whenActivatedDo: [ :selection | value := selection value ].

	presenter text selectionInterval: (1 to: 16).
	[presenter doEvaluateAndGo] on: OCUndeclaredVariableWarning do: [ :warn | warn declareGlobal ].
	
	self assert: value equals:  nil.
	
	self assert: (Smalltalk globals includesKey: #MyGlobalForTest).
	Smalltalk globals removeKey: #MyGlobalForTest
]

{ #category : #tests }
StPlaygroundPagePresenterTest >> testToolbarActions [
	| group commands class |

	class := self classFactory newSubclassOf: StPlaygroundToolbarExtensionCommand.
	
	group := presenter toolbarActions.
	commands := group allCommands collect: [ :each | each innerCommand class ] as: Array.	
	self assert: (commands includes: class).

]
