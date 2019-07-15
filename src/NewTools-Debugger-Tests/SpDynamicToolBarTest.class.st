Class {
	#name : #SpDynamicToolBarTest,
	#superclass : #TestCase,
	#instVars : [
		'toolbar'
	],
	#category : #'NewTools-Debugger-Tests'
}

{ #category : #running }
SpDynamicToolBarTest >> setUp [
	super setUp.
	toolbar := SpDynamicToolbarPresenter basicNew
	
]

{ #category : #tests }
SpDynamicToolBarTest >> testDefaultDebuggingActionsPragmas [
	| debuggingActionsPragmas |
	debuggingActionsPragmas := toolbar debuggingActionsPragmas.
	self assert: debuggingActionsPragmas notEmpty.
	self assert: debuggingActionsPragmas size equals: 1.
	self assert: debuggingActionsPragmas equals: {#debuggingAction}
]

{ #category : #tests }
SpDynamicToolBarTest >> testModifyDebuggingActionsPragmas [
	toolbar debuggingActionsPragmas: { #advancedDebuggingActions }.
	self assert: toolbar debuggingActionsPragmas equals: { #advancedDebuggingActions }
]
