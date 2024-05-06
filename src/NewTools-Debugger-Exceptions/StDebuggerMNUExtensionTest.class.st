Class {
	#name : 'StDebuggerMNUExtensionTest',
	#superclass : 'TestCase',
	#instVars : [
		'oldShowInDebuggerSetting',
		'debugger'
	],
	#category : 'NewTools-Debugger-Exceptions',
	#package : 'NewTools-Debugger-Exceptions'
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

	^ StDebuggerMNUExtension
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
		debugger debuggerActionModel ifNotNil: [ :actionModel |
			actionModel clear.
			actionModel session ifNotNil: [ :s | s clear ] ].
		debugger close ].

	StTestDebuggerProvider removeSelector: #foobar.
	self extensionTested showInDebugger: oldShowInDebuggerSetting.
	super tearDown
]

{ #category : 'tests' }
StDebuggerMNUExtensionTest >> testExtensionDisplaysWhenDNU [

	self hideExtensionInDebugger.
	debugger := StTestDebuggerProvider new debuggerWithDNUContext.
	debugger
		application: debugger class currentApplication;
		initialize.

	self assert:
		debugger debuggerActionModel isInterruptedContextDoesNotUnderstand.
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
		debugger debuggerActionModel isInterruptedContextDoesNotUnderstand.
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

	dnuMessage := debugger debuggerActionModel contextPredicate exception
		              message.

	self assert: dnuMessage selector identicalTo: #foobar.

	"We create the missing method"
	extension addMethod.

	"Now, we shouldn't be able to create the method and the extension should be hidden."
	self deny:
		debugger debuggerActionModel isInterruptedContextDoesNotUnderstand.
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
		debugger debuggerActionModel isInterruptedContextDoesNotUnderstand.
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
