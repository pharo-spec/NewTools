"
I subclass and replace SpCodePresenter in the debugger code pane.
I intercept code evaluation normally called on instances of SpCodePresenter, and evaluate it on behalf of the debugged process.

Evaluating in the debugged process is necessary for dynamic variables which are defined in the debugged process but not in the active process. 
"
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
