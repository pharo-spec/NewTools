Class {
	#name : 'StDebuggerMNUExtensionTest',
	#superclass : 'TestCase',
	#instVars : [
		'oldShowInDebuggerSetting',
		'debugger'
	],
	#category : 'NewTools-Debugger-Tests-Presenters',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Presenters'
}

{ #category : 'action' }
StDebuggerMNUExtensionTest >> displayExtensionInDebugger [

	self extensionTested showInDebugger: true
]

{ #category : 'private - testing' }
StDebuggerMNUExtensionTest >> extensionClassesOfDebugger [

	^ debugger extensionTools collect: [ :extension | extension class ]
]

{ #category : 'accessing' }
StDebuggerMNUExtensionTest >> extensionTested [

	^ StDebuggerMethodImplementorPresenter
]

{ #category : 'action' }
StDebuggerMNUExtensionTest >> hideExtensionInDebugger [

	self extensionTested showInDebugger: false
]

{ #category : 'running' }
StDebuggerMNUExtensionTest >> setUp [

	super setUp.

	oldShowInDebuggerSetting := self extensionTested showInDebugger
]

{ #category : 'running' }
StDebuggerMNUExtensionTest >> tearDown [

	debugger ifNotNil: [
		debugger unsubscribeFromSystemAnnouncer.
		debugger debuggerClientModel ifNotNil: [ :actionModel |
			actionModel clear.
			actionModel session ifNotNil: [ :s | s clear ] ].
		debugger close ].

	(StTestDebuggerProvider includesSelector: #foobar)
		ifTrue: [ StTestDebuggerProvider removeSelector: #foobar ].
	self extensionTested showInDebugger: oldShowInDebuggerSetting.
	super tearDown
]

{ #category : 'tests' }
StDebuggerMNUExtensionTest >> testExtensionDisplaysFilteredProtocolsDNU [

	self hideExtensionInDebugger.
	debugger := StTestDebuggerProvider new debuggerWithDNUContext.
	debugger
		application: debugger class currentApplication;
		initialize.

	self assert: debugger debuggerClientModel isInterruptedContextDoesNotUnderstand.
	self assert: debugger canExecuteCreateMissingMethodCommand.

	self displayExtensionInDebugger.

self assertCollection:  ( (debugger extensionTools first instVarNamed: #selectedProtocol) items collect: #name)  hasSameElements:  StTestDebuggerProvider protocolNames.
self denyCollection: ( (debugger extensionTools first instVarNamed: #selectedProtocol) items collect: #name) includesAny: Object protocolNames.
]

{ #category : 'tests' }
StDebuggerMNUExtensionTest >> testExtensionDisplaysObjectProtocolsDNU [

	| extensionFilteredProtocols |
	self hideExtensionInDebugger.
	debugger := StTestDebuggerProvider new debuggerWithObjectClassDNUContext.
	debugger
		application: debugger class currentApplication;
		initialize.

	self assert: debugger debuggerClientModel isInterruptedContextDoesNotUnderstand.
	self assert: debugger canExecuteCreateMissingMethodCommand.

	self displayExtensionInDebugger.
extensionFilteredProtocols:=( (debugger extensionTools first instVarNamed: #selectedProtocol) items ).
self assertCollection:  (extensionFilteredProtocols collect: #name)  includesAll:  Object class protocolNames.
self denyCollection: (extensionFilteredProtocols reject: #isExtensionProtocol thenCollect: #name) includesAny: ((Object allSuperclasses collect:#protocols) flattened reject:#isExtensionProtocol thenCollect:#name).
]

{ #category : 'tests' }
StDebuggerMNUExtensionTest >> testExtensionDisplaysWhenDNU [

	self hideExtensionInDebugger.
	debugger := StTestDebuggerProvider new debuggerWithDNUContext.
	debugger
		application: debugger class currentApplication;
		initialize.

	self assert:
		debugger debuggerClientModel isInterruptedContextDoesNotUnderstand.
	self assert: debugger canExecuteCreateMissingMethodCommand.

	self
		denyCollection: self extensionClassesOfDebugger
		includesAll: { self extensionTested }.

	"We display the extension"
	self displayExtensionInDebugger.

	self
		assertCollection: self extensionClassesOfDebugger
		includesAll: { self extensionTested }
]

{ #category : 'tests' }
StDebuggerMNUExtensionTest >> testExtensionHidesAfterDNUMethodHasBeenCreated [

	| extension dnuMessage |
	self hideExtensionInDebugger.
	debugger := StTestDebuggerProvider new debuggerWithDNUContext.
	debugger
		application: debugger class currentApplication;
		initialize.

	self assert:
		debugger debuggerClientModel isInterruptedContextDoesNotUnderstand.
	self assert: debugger canExecuteCreateMissingMethodCommand.

	self
		denyCollection: self extensionClassesOfDebugger
		includesAll: { self extensionTested }.

	"We display the extension"
	self displayExtensionInDebugger.

	"But it is not displayed because the context is not a DNU"
	self
		assertCollection: self extensionClassesOfDebugger
		includesAll: { self extensionTested }.

	extension := debugger extensionTools detect: [ :each |
		             each class == self extensionTested ].

	dnuMessage := debugger debuggerClientModel contextPredicate exception
		              message.

	self assert: dnuMessage selector identicalTo: #foobar.

	"We create the missing method"
	extension implementMethod.

	"Now, we shouldn't be able to create the method and the extension should be hidden."
	self deny:
		debugger debuggerClientModel isInterruptedContextDoesNotUnderstand.
	self deny: debugger canExecuteCreateMissingMethodCommand.
	self
		denyCollection: debugger extensionTools
		includesAll: { extension }
]

{ #category : 'tests' }
StDebuggerMNUExtensionTest >> testExtensionHidesWhenNotDNU [

	self hideExtensionInDebugger.
	debugger := StTestDebuggerProvider new debuggerWithRecursiveContext.
	debugger
		application: debugger class currentApplication;
		initialize.

	self deny:
		debugger debuggerClientModel isInterruptedContextDoesNotUnderstand.
	self deny: debugger canExecuteCreateMissingMethodCommand.

	self
		denyCollection: self extensionClassesOfDebugger
		includesAll: { self extensionTested }.

	"We display the extension"
	self displayExtensionInDebugger.

	"But it is not displayed because the context is not a DNU"
	self
		denyCollection: self extensionClassesOfDebugger
		includesAll: { self extensionTested }
]
