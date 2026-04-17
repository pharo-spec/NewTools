Class {
	#name : 'StPlaygroundPagePresenterTest',
	#superclass : 'StPlaygroundBaseTest',
	#instVars : [
		'classFactory'
	],
	#category : 'NewTools-Playground-Tests',
	#package : 'NewTools-Playground-Tests'
}

{ #category : 'private' }
StPlaygroundPagePresenterTest >> classFactory [

	^ classFactory ifNil: [ classFactory := ClassFactoryForTestCase environment: SystemEnvironment new ]
]

{ #category : 'accessing' }
StPlaygroundPagePresenterTest >> classToTest [

	^ StPlaygroundPagePresenter
]

{ #category : 'initialization' }
StPlaygroundPagePresenterTest >> initializeInstanceBeforeInitialization: aPresenter [

	aPresenter setModelBeforeInitialization: self newPage
]

{ #category : 'running' }
StPlaygroundPagePresenterTest >> setUp [ 
	super setUp.

	presenter initialize.
]

{ #category : 'running' }
StPlaygroundPagePresenterTest >> tearDown [

	classFactory ifNotNil: [ 
		classFactory cleanUp.
		classFactory := nil ].
	super tearDown
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testAddMenuCommandsTo [

	| group commands class |
	class := self classFactory make: [ :aBuilder | aBuilder superclass: StPlaygroundMenuExtensionCommand ].

	group := CmCommandGroup forSpec.
	presenter addMenuCommandsTo: group.
	commands := group allCommands collect: [ :each | each innerCommand class ] as: Array.
	self assert: (commands includes: class)
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testAddToolbarCommandsTo [

	| group commands class |
	class := self classFactory make: [ :aBuilder | aBuilder superclass: StPlaygroundToolbarExtensionCommand ].

	group := CmCommandGroup forSpec.
	presenter addToolbarCommandsTo: group.
	commands := group allCommands collect: [ :each | each innerCommand class ] as: Array.
	self assert: (commands includes: class)
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testContents [
	|string|
	string := 'coucou'.
	self openInstance.
	
	self assert: presenter contents equals:''.
	presenter contents: string.
	self assert: presenter contents equals: string.
]

{ #category : 'tests - commands' }
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

{ #category : 'tests - commands' }
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

{ #category : 'tests - commands' }
StPlaygroundPagePresenterTest >> testDoEvaluateDeclareGlobal [
	| value |

	self skip: 'Because a change in the compiler API, there is no way to hijack OCUndeclaredVariableWarning when the compiler is used a in legacy interactive mode (but such hijack is only performed in this test). So disable the test for now.'.

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

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testEnsureContentsFlushed [
	|page|
	page := StPlaygroundPage new contents: 'test'.
	self openInstance.
	
	self assert: presenter page contents equals: ''.
	
	presenter loadPage: page.
	presenter ensureContentsFlushed.
	
	self assert: presenter page contents equals: 'test'.
	
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testLoadPage [ 
	|page|
	page := (StPlaygroundPage new) contents: 'test'.
	page flush.
	self openInstance.
	
	self assert: presenter text text equals: ''.
	presenter loadPage: page.
	self assert: presenter text text equals: 'test'.
	
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testPageIsSavedWhenExecutingACommand [
	| memory fileReference |
	
	memory := FileSystem memory.
	fileReference := memory / 'page.ph'. 
	fileReference writeStreamDo: [ :stream | ].
	presenter loadPage: (StPlaygroundPage fromReference: fileReference).
	"ensure we do not save in the inner process by mistake"
	presenter page timeToWait: 1 minute.
	"we need the activation otherwise the command we are using will not work :("
	presenter whenActivatedDo: [ :selection | "not needed" ].
	
	self openInstance.
	
	self assert: presenter page contents equals: ''.
	presenter contents: '42 factorial'.
	presenter text selectionInterval: (1 to: 2).
	self 
		assert: fileReference contents 
		equals: ''.
	presenter doEvaluateAndGo.
	self 
		assert: fileReference contents 
		equals: '42 factorial'
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testRemoveAllBindings [
	self newPage.
	
	presenter interactionModel addBindingNamed: #this with: 0. 
	self assert: (presenter text interactionModel hasBindingOf: #this ).
	presenter removeAllBindings.
	self deny: (presenter text interactionModel hasBindingOf: #this ).
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testSelectAll [
	|string|
	string := 'test
coucou
non non non
pk tu prend le dernier'.

	self openInstance.
	
	self assert: presenter text text equals: ''.
	
	presenter contents: string.
	
	self assert: presenter selectAll text equals: string.
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testSelectedTextOrLine [
	|string|
	string := 'test
coucou
non non non
pk tu prend le dernier'.

	self openInstance.
	
	self assert: presenter text text equals: ''.
	
	presenter contents: string.
	
	self assert: presenter selectedTextOrLine equals: ((string substrings: String cr) at: 4).
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testToolbarActions [

	| group commands class |
	class := self classFactory make: [ :aBuilder | aBuilder superclass: StPlaygroundToolbarExtensionCommand ].

	group := presenter toolbarActions.
	commands := group allCommands collect: [ :each | each innerCommand class ] as: Array.
	self assert: (commands includes: class)
]

{ #category : 'tests' }
StPlaygroundPagePresenterTest >> testUpdateContents [
	
	self openInstance.
	
	self assert: presenter page contents equals: ''.
	
	presenter updateContents: 'test'.
	presenter ensureContentsFlushed.
	
	self assert: presenter page contents equals: 'test'.
	
]
