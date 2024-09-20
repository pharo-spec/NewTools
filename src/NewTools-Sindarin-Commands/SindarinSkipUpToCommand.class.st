"
Equivalent of the `StRunToSelectionCommand` except that it skips all bytecodes (even jump bytecodes) to the selection instead of stepping them.
The only bytecodes that cannot be skipped are all return bytecodes, whether they are implicit or explicit.
All push and pop bytecodes are performed but, in this case the values that are pushed on the stack are altered so that the program doesn't do anything.

You should be careful before using this command as it may skip a bytecode that you need to execute in order to execute the rest of your program.

Known issue: 
- It is not possible yet to skip a return node, which could be problematic if we want to skip a return node in an ifTrue: block for instance, to see what happens when an ifFalse: block is executed
"
Class {
	#name : 'SindarinSkipUpToCommand',
	#superclass : 'SindarinSkipAllToSelectionCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinSkipUpToCommand class >> defaultDescription [
	^ 'Skips execution and stops before the selected instruction (or the instruction preceding the cursor).'
]

{ #category : 'accessing - defaults' }
SindarinSkipUpToCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ 'Skip up to'
]

{ #category : 'hooks' }
SindarinSkipUpToCommand >> execute [
	| targetNode |
	
	self flag: 'Context should actually be a debugger or a sindarin debugger'.
	self flag: 'Suspicious call to internal debugger UI state'.
	targetNode := self context sindarinDebugger
		bestNodeFor: self context code selectionInterval.
	self context sindarinDebugger skipUpToNode: targetNode.
	self context forceSessionUpdate
]
