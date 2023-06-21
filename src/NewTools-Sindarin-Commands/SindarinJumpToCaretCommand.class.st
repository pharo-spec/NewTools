"
This command allows to jump to caret to move the program execution to the node associated to the caret.

Even if this command relies on the SkipUpTo command, both are very different:
- JumpToCaret allows to enter non-inlined blocks but SkipUpTo can't
- SkipUpTo only allows to skip instructions forward but not backward; whereas JumpToCaret allows to do it.

Known issues:
- A bug occurs when we enter a block if its creation is the very first bytecode that is executed in the first statement of the method. In this case, we lose the array of shared temps between the block context and its parent context.
- JumpToCaret does not allow to jump into an `ifFalse:` block in an `ifTrue:ifFalse:` message if the `ifTrue:` block contains an explicit return.

This command should only be used in the suspended context in the debugger.

When we enter a block, it creates a context for this block that becomes the suspended context. If we leave the block via steps, you will go back to the parent context after the block creation.

When you exit a block via MoveToCaret, then the caret should be somewhere in the lexical context and all contexts that are above the context that contains the aimed node are discarded.
"
Class {
	#name : #SindarinJumpToCaretCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'accessing - defaults' }
SindarinJumpToCaretCommand class >> defaultDescription [
	^ 'Jump to caret so that the next instruction that will be executed is the instruction associated to the node associated to the caret. All necessary arguments are pushed on the stack but everything else is skipped and the program state (e.g : variable bindings) stay the same.'
]

{ #category : #initialization }
SindarinJumpToCaretCommand class >> defaultIconName [
	^ #smallItalic
]

{ #category : #'accessing - defaults' }
SindarinJumpToCaretCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand:1>
	^ '[Exp.] Jump to caret'
]

{ #category : #execution }
SindarinJumpToCaretCommand >> execute [

	| targetNode |
	self flag:
		'Context should actually be a debugger or a sindarin debugger'.
	self flag: 'Suspicious call to internal debugger UI state'.
	targetNode := self context sindarinDebugger bestNodeFor:
		              self context code selectionInterval.
	self context sindarinDebugger moveToNode: targetNode.
	self context forceSessionUpdate.
]
