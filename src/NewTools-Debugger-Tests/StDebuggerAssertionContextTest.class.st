Class {
	#name : 'StDebuggerAssertionContextTest',
	#superclass : 'TestCase',
	#instVars : [
		'session',
		'debugger'
	],
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
StDebuggerAssertionContextTest >> tearDown [
	session ifNotNil:[session clear].
	debugger ifNotNil: [ 
		debugger close.
		debugger unsubscribeFromSystemAnnouncer.
		debugger debuggerActionModel ifNotNil: [ :actionModel |
			actionModel clear.
			actionModel session ifNotNil: [ :s | s clear ] ] ].
	super tearDown 
]

{ #category : 'tests' }
StDebuggerAssertionContextTest >> testFindFailedAssertionContextInSenderChain [

	debugger := StTestDebuggerProvider new debuggerWithFailingAssertionContext.
	session := debugger session.
	self assert: session interruptedContext findFailedAssertionContextInSenderChain notNil.
	session clear.
	debugger close.
	
	debugger := StTestDebuggerProvider new debuggerWithDNUContext. 
	session := debugger session.
	self should: [ session interruptedContext findFailedAssertionContextInSenderChain ] raise: StDebuggeAssertionFailureContextNotFound.
	
]

{ #category : 'tests' }
StDebuggerAssertionContextTest >> testFindFailedAssertionResultsInSenderChain [
	| assertionResult|
	debugger := StTestDebuggerProvider new debuggerWithFailingAssertionContext.
	session := debugger session.
	assertionResult := session interruptedContext findFailedAssertionResultsInSenderChain.
	
	self assert: assertionResult actual equals: 4.
	self assert: assertionResult expected equals: 2.
	
	session clear.
	debugger close.
	
	debugger := StTestDebuggerProvider new debuggerWithDNUContext. 
	session := debugger session.
	self should: [session interruptedContext findFailedAssertionResultsInSenderChain] raise: StDebuggeAssertionFailureContextNotFound.
	
]
