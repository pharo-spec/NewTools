Class {
	#name : #StDebuggerExtensionMechanismTest,
	#superclass : #TestCase,
	#instVars : [
		'debugger',
		'oldActivatedExtensions'
	],
	#category : #'NewTools-Debugger-Tests-Presenters'
}

{ #category : #accessing }
StDebuggerExtensionMechanismTest >> debugger [
	^ debugger ifNil: [ debugger := self debuggerClass basicNew ]
]

{ #category : #accessing }
StDebuggerExtensionMechanismTest >> debuggerClass [
	^ StDebugger
]

{ #category : #running }
StDebuggerExtensionMechanismTest >> setUp [

	super setUp.
	oldActivatedExtensions := self debuggerClass activatedDebuggerExtensions.
	StDummyDebuggerPresenter showInDebugger: false
]

{ #category : #running }
StDebuggerExtensionMechanismTest >> tearDown [

	| allDebuggerExtensions testClass |
	testClass := StDebuggerExtensionGeneratorForTests testClass.
	allDebuggerExtensions := StDebugger extensionToolsClasses.
	allDebuggerExtensions do: [ :extension |
		| wasActivated |
		wasActivated := oldActivatedExtensions includes: extension.
		extension showInDebugger = wasActivated ifFalse: [
			extension showInDebugger: wasActivated ] ].
	testClass showInDebugger: false.
	StDummyDebuggerPresenter showInDebugger: false.
	super tearDown
]

{ #category : #tests }
StDebuggerExtensionMechanismTest >> testDynamicLayoutWithAndWithoutExtension [

	| dbg toolPage session |
	session := StTestDebuggerProvider new sessionForDebuggerTests.
	self debuggerClass extensionToolsClasses do: [ :extension |
		extension showInDebugger: false ].
	dbg := self debugger
		       session: session;
		       application: self debuggerClass currentApplication;
		       initialize;
		       yourself.

	self assertEmpty: dbg extensionTools.
	self assertEmpty: dbg extensionToolNotebook pages.
	self denyCollection: dbg stackAndCodeContainer children includesAny: {#extensionToolsNotebook }.

	"We activate an extension"
	StDummyDebuggerPresenter showInDebugger: true.
	self assert: dbg extensionToolNotebook pages size equals: 1.
	self assert: dbg extensionTools size equals: 1.
	self assertCollection: dbg stackAndCodeContainer children includesAny: {#extensionToolsNotebook }.
	toolPage := dbg extensionToolNotebook pages first.
	self assert: toolPage class identicalTo: SpNotebookPage.
	self
		assert: toolPage presenterProvider value class
		identicalTo: StDummyDebuggerPresenter.
	self
		assert: toolPage title
		equals: StDummyDebuggerPresenter new debuggerExtensionToolName.
	self
		assert: toolPage presenterProvider value debugger
		identicalTo: dbg.
	self
		assertCollection: dbg extensionTools
		includesAll: { toolPage presenterProvider value }.

	"We remove the extension"
	StDummyDebuggerPresenter showInDebugger: false.
	self assertEmpty: dbg extensionTools.
	self assertEmpty: dbg extensionToolNotebook pages.
	self denyCollection: dbg stackAndCodeContainer children includesAny: {#extensionToolsNotebook }
]

{ #category : #'tests - extensions' }
StDebuggerExtensionMechanismTest >> testExtensionToolsClasses [

	self
		assertCollection: StDebugger extensionToolsClasses
		equals: (TStDebuggerExtension users reject: [ :extension |
				 extension isOnlyForTests ])
]

{ #category : #'tests - extensions' }
StDebuggerExtensionMechanismTest >> testHasAnyActivatedExtensions [

	| testClass |
	testClass := StDebuggerExtensionGeneratorForTests testClass.
	self deny:
		(self debuggerClass hasAnyActivatedExtension: { testClass }).
	testClass showInDebugger: true.
	self assert:
		(self debuggerClass hasAnyActivatedExtension: { testClass })
]

{ #category : #'tests - extensions' }
StDebuggerExtensionMechanismTest >> testInstantiateExtensionToolsPage [
	|dbg toolPage|
	dbg := self debugger.
	toolPage := dbg instantiateExtensionToolsPage: StDummyDebuggerPresenter.
	self assert: toolPage class identicalTo: SpNotebookPage.
	self assert: toolPage presenterProvider value class identicalTo: StDummyDebuggerPresenter.
	self assert: toolPage title equals: StDummyDebuggerPresenter new debuggerExtensionToolName.
	self assert: toolPage presenterProvider value debugger identicalTo: dbg.
	self assertCollection: dbg extensionTools includesAll: { toolPage presenterProvider value}.
	 
]

{ #category : #'tests - extensions' }
StDebuggerExtensionMechanismTest >> testRegisterExtensionTool [
	|dbg object|
	dbg := self debugger.
	self assertEmpty: dbg extensionTools.
	dbg registerExtensionTool: (object := Object new).
	self assert: dbg extensionTools size equals: 1.
	self assertCollection: dbg extensionTools equals: { object } asOrderedCollection 
]

{ #category : #'tests - extensions' }
StDebuggerExtensionMechanismTest >> testUsesExtensions [

	| testClass |
	testClass := StDebuggerExtensionGeneratorForTests testClass.
	
	self debuggerClass extensionToolsClasses do: [ :extension |
		extension showInDebugger: false ].

	self assertEmpty: self debuggerClass activatedDebuggerExtensions.
	self deny: self debuggerClass usesExtensions.
	self debuggerClass extensionToolsClasses ifNotEmpty: [
		| activatedExtension |
		activatedExtension := self debuggerClass extensionToolsClasses
			                      asOrderedCollection first.
		activatedExtension showInDebugger: true.
		self
			assertCollection: self debuggerClass activatedDebuggerExtensions
			hasSameElements: { activatedExtension }.
		self assert: self debuggerClass usesExtensions ]
]
