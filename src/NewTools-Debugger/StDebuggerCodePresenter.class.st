Class {
	#name : 'StDebuggerCodePresenter',
	#superclass : 'SpCodePresenter',
	#instVars : [
		'debuggerActionModel'
	],
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'accessing' }
StDebuggerCodePresenter >> debuggerActionModel: anObject [

	debuggerActionModel := anObject
]

{ #category : 'command support' }
StDebuggerCodePresenter >> evaluate: aString onCompileError: compileErrorBlock onError: errorBlock [

	^ Processor activeProcess
		  evaluate: [
			  super
				  evaluate: aString
				  onCompileError: compileErrorBlock
				  onError: errorBlock ]
		  onBehalfOf: debuggerActionModel interruptedProcess
]
