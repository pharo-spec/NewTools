Class {
	#name : #StDebuggerCodeCommandTreeBuilder,
	#superclass : #StDebuggerCommandTreeBuilder,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerCodeCommandTreeBuilder class >> displayStrategy [
	^CmUIDisplayAsGroup
]

{ #category : #accessing }
StDebuggerCodeCommandTreeBuilder class >> groupDescription [
	^ 'Debug actions from code'
]

{ #category : #accessing }
StDebuggerCodeCommandTreeBuilder class >> groupName [ 	
	^'Code'
]

{ #category : #building }
StDebuggerCodeCommandTreeBuilder >> buildDebuggerCommandGroup [
	| codeGroup |
	codeGroup := self group.
	codeGroup decoratedGroup register: self codeDebugCommands
]

{ #category : #commands }
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
	self codeExtensionCommandsClasses
		do: [ :cmdClass | 
			group
				register: (self buildSpecCommand: cmdClass forContext: stDebuggerInstance) ].
	^ group
]

{ #category : #accessing }
StDebuggerCodeCommandTreeBuilder >> codeDebugCommandsDescription [
	^'Execution control'
]

{ #category : #accessing }
StDebuggerCodeCommandTreeBuilder >> codeDebugCommandsGroupName [
	^'Execution'
]

{ #category : #'accessing - commands classes' }
StDebuggerCodeCommandTreeBuilder >> codeExecutionControlCommandsClasses [
	^ {StRunToSelectionCommand}
]

{ #category : #'accessing - commands classes' }
StDebuggerCodeCommandTreeBuilder >> codeExtensionCommandsClasses [
	| extensionPragmas |
	extensionPragmas := StDebugger
		collectExtendedToolsPragmaFor: #codeExtensionDebugCommand:.
	^ extensionPragmas collect: [ :prg | prg methodClass soleInstance ]
]
