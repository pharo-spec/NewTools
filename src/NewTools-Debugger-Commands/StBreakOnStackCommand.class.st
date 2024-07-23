"
I am a debugger command class that allows to select an instruction in the debugger to dynamically install a breakpoint on the corresponding AST node.
"
Class {
	#name : 'StBreakOnStackCommand',
	#superclass : 'StDebuggerCommand',
	#category : 'NewTools-Debugger-Commands',
	#package : 'NewTools-Debugger-Commands'
}

{ #category : 'default' }
StBreakOnStackCommand class >> defaultDescription [

	^ 'Recompile method to add a breakpoint before selection and replace the compiled methods on stack by its reflective version'
]

{ #category : 'initialization' }
StBreakOnStackCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : 'default' }
StBreakOnStackCommand class >> defaultName [

	<toolbarDebugCommand: 50>
	^ 'Break'
]

{ #category : 'initialization' }
StBreakOnStackCommand class >> defaultShortcut [

	^ nil
]

{ #category : 'executing' }
StBreakOnStackCommand >> execute [

	self debugger breakOnStack
]
