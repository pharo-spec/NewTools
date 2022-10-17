Class {
	#name : #SindarinMoveToCaretCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'accessing - defaults' }
SindarinMoveToCaretCommand class >> defaultDescription [
	^ 'Move caret so that the next instruction that will be executed is the instruction associated to the node associated to the caret. All necessary arguments are pushed on the stack but everything else is skipped and the program state (e.g : variable bindings) stay the same.'
]

{ #category : #'accessing - defaults' }
SindarinMoveToCaretCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ '[Exp.] Move to caret, while keeping current program state '
]

{ #category : #execution }
SindarinMoveToCaretCommand >> execute [

	| targetNode |
	self flag:
		'Context should actually be a debugger or a sindarin debugger'.
	self flag: 'Suspicious call to internal debugger UI state'.
	targetNode := self context sindarinDebugger bestNodeFor:
		              self context code selectionInterval.
	self context sindarinDebugger moveToNode: targetNode.
	self context forceSessionUpdate
]
