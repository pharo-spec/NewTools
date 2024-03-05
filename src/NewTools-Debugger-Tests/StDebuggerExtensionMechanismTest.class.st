Class {
	#name : 'StDebuggerExtensionMechanismTest',
	#superclass : 'TestCase',
	#instVars : [
		'debugger',
		'oldActivatedExtensions'
	],
	#category : 'NewTools-Debugger-Tests-Presenters',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Presenters'
}

{ #category : 'accessing' }
StDebuggerExtensionMechanismTest >> debugger [
	^ debugger ifNil: [ debugger := self debuggerClass basicNew ]
]

{ #category : 'accessing' }
StDebuggerExtensionMechanismTest >> debuggerClass [
	^ StDebugger
]

{ #category : 'helpers' }
StDebuggerExtensionMechanismTest >> disableTStDebuggerExtensionTestClassAsExtension [

	TStDebuggerExtensionTestClass class compile: 'isOnlyForTests

	^ true'
]

{ #category : 'helpers' }
StDebuggerExtensionMechanismTest >> enableTStDebuggerExtensionTestClassAsExtension [

	TStDebuggerExtensionTestClass class compile: 'isOnlyForTests

	^ false'
]

{ #category : 'running' }
StDebuggerExtensionMechanismTest >> setUp [

	super setUp.
	oldActivatedExtensions := self debuggerClass activatedDebuggerExtensions.
	StDummyDebuggerPresenter showInDebugger: false
]

{ #category : 'running' }
StDebuggerExtensionMechanismTest >> tearDown [

	| allDebuggerExtensions |
	debugger ifNotNil: [
		debugger close.
		debugger unsubscribeFromSystemAnnouncer.
		debugger unsubscribeFromActionModel.
		debugger clearDebugSession.
		debugger clearDebuggerActionModel ].
	allDebuggerExtensions := StDebugger extensionToolsClasses.
	allDebuggerExtensions do: [ :extension |
		| wasActivated |
		wasActivated := oldActivatedExtensions includes: extension.
		extension showInDebugger = wasActivated ifFalse: [
			extension showInDebugger: wasActivated ] ].
	TStDebuggerExtensionTestClass showInDebugger: false.
	StDummyDebuggerPresenter showInDebugger: false.
	self disableTStDebuggerExtensionTestClassAsExtension.
	super tearDown
]

{ #category : 'tests' }
StDebuggerExtensionMechanismTest >> testDynamicLayoutWithAndWithoutExtension [

	| toolPage session |
	session := StTestDebuggerProvider new sessionForDebuggerTests.
	self debuggerClass extensionToolsClasses do: [ :extension |
		extension showInDebugger: false ].
	debugger := self debugger
		            session: session;
		            application: self debuggerClass currentApplication;
		            initialize;
		            yourself.

	self assertEmpty: debugger extensionTools.
	self assertEmpty: debugger extensionToolNotebook pages.
	self
		denyCollection: debugger stackAndCodeContainer children
		includesAny: { #extensionToolsNotebook }.

	"We activate an extension"
	StDummyDebuggerPresenter showInDebugger: true.
	self assert: debugger extensionToolNotebook pages size equals: 1.
	self assert: debugger extensionTools size equals: 1.
	self
		assertCollection: debugger stackAndCodeContainer children
		includesAny: { #extensionToolsNotebook }.
	toolPage := debugger extensionToolNotebook pages first.
	self assert: toolPage class identicalTo: SpNotebookPage.
	self
		assert: toolPage presenterProvider value class
		identicalTo: StDummyDebuggerPresenter.
	self
		assert: toolPage title
		equals: StDummyDebuggerPresenter new debuggerExtensionToolName.
	self
		assert: toolPage presenterProvider value debugger
		identicalTo: debugger.
	self
		assertCollection: debugger extensionTools
		includesAll: { toolPage presenterProvider value }.

	"We remove the extension"
	StDummyDebuggerPresenter showInDebugger: false.
	self assertEmpty: debugger extensionTools.
	self assertEmpty: debugger extensionToolNotebook pages.
	self
		denyCollection: debugger stackAndCodeContainer children
		includesAny: { #extensionToolsNotebook }
]

{ #category : 'tests - extensions' }
StDebuggerExtensionMechanismTest >> testExtensionToolsClasses [

	self
		assertCollection: StDebugger extensionToolsClasses
		equals: (TStDebuggerExtension users reject: [ :extension |
				 extension isOnlyForTests ])
]

{ #category : 'tests - extensions' }
StDebuggerExtensionMechanismTest >> testHasAnyActivatedExtensions [

	self deny: (self debuggerClass hasAnyActivatedExtension: { TStDebuggerExtensionTestClass }).
	TStDebuggerExtensionTestClass showInDebugger: true.
	self assert: (self debuggerClass hasAnyActivatedExtension: { TStDebuggerExtensionTestClass })
]

{ #category : 'tests - extensions' }
StDebuggerExtensionMechanismTest >> testInstantiateExtensionToolsPage [

	| dbg toolPage |
	dbg := self debugger.
	toolPage := dbg instantiateExtensionToolsPage:
		            StDummyDebuggerPresenter.
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
		includesAll: { toolPage presenterProvider value }
]

{ #category : 'tests - extensions' }
StDebuggerExtensionMechanismTest >> testRegisterExtensionTool [
	|dbg object|
	dbg := self debugger.
	self assertEmpty: dbg extensionTools.
	dbg registerExtensionTool: (object := Object new).
	self assert: dbg extensionTools size equals: 1.
	self assertCollection: dbg extensionTools equals: { object } asOrderedCollection 
]

{ #category : 'tests - extensions' }
StDebuggerExtensionMechanismTest >> testUsesExtensions [

	| extensionClasses activatedExtension |

	"In case there are no available extensions in the system, we add a test extension to the system.
	We then assume that there is always one extension in the extension collection of the system."
	self enableTStDebuggerExtensionTestClassAsExtension.
	extensionClasses := self debuggerClass extensionToolsClasses.
	self
		assertCollection: extensionClasses
		includesAny: { TStDebuggerExtensionTestClass }.

	"We deactivate all extensions: the debugger should not have any activated extension, 
	and should not use extensions in its layout."
	self debuggerClass extensionToolsClasses do: [ :extension |
		extension showInDebugger: false ].

	self assertEmpty: self debuggerClass activatedDebuggerExtensions.
	self deny: self debuggerClass usesExtensions.

	"We activate the first extension in the extension collection:
	the debugger should have this extension activated, and should use extensions in its layout."
	activatedExtension := extensionClasses asOrderedCollection first.
	activatedExtension showInDebugger: true.
	self
		assertCollection: self debuggerClass activatedDebuggerExtensions
		hasSameElements: { activatedExtension }.
	self assert: self debuggerClass usesExtensions
]
