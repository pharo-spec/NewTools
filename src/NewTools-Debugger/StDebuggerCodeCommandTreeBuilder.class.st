"
I build the default command tree for the debugger code presenter.
The command classes I instantiate are specified under the ""accessing - commands classes"" protocol.
The group names and descriptions are specified under the ""accessing"" protocol.

You can modify the default groups names and descriptions and the default commands by modifying my code, but I am not meant to be extended through subclassing.
As I provide the default debugger commands, you should only extend me by using the Spec extension mechanism and not by subclassing me.
Using me to add command in the tree makes them default for the debugger code presenter.
"
Class {
	#name : 'StDebuggerCodeCommandTreeBuilder',
	#superclass : 'StDebuggerCommandTreeBuilder',
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'accessing' }
StDebuggerCodeCommandTreeBuilder class >> displayStrategy [
	^CmUIDisplayAsSubMenu 
]

{ #category : 'accessing' }
StDebuggerCodeCommandTreeBuilder class >> groupDescription [
	^ 'Debug actions from code'
]

{ #category : 'accessing' }
StDebuggerCodeCommandTreeBuilder class >> groupName [ 	
	^'Code'
]

{ #category : 'building' }
StDebuggerCodeCommandTreeBuilder >> buildDebuggerCommandGroup [
	| codeGroup |
	codeGroup := self group.
	codeGroup decoratedGroup register: self codeDebugCommands.
	codeGroup beDisplayedAsGroup
]

{ #category : 'commands' }
StDebuggerCodeCommandTreeBuilder >> codeDebugCommands [
	| group |
	group := (CmCommandGroup named: self codeDebugCommandsGroupName)
		asSpecGroup.
	group beDisplayedAsGroup.
	group description: self codeDebugCommandsDescription.
	group iconName: #smallDoIt.
	self codeExecutionControlCommandsClasses
		do: [ :cmdClass | 
			group
				register: (self buildSpecCommand: cmdClass forContext: stDebuggerInstance) ].
	^ group
]

{ #category : 'accessing' }
StDebuggerCodeCommandTreeBuilder >> codeDebugCommandsDescription [
	^'Execution control'
]

{ #category : 'accessing' }
StDebuggerCodeCommandTreeBuilder >> codeDebugCommandsGroupName [
	^'Execution'
]

{ #category : 'accessing - commands classes' }
StDebuggerCodeCommandTreeBuilder >> codeExecutionControlCommandsClasses [
	^ {StRunToSelectionCommand}
]
