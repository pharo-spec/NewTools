Class {
	#name : #StDebuggerConfigurationCommandTreeBuilder,
	#superclass : #StDebuggerCommandTreeBuilder,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerConfigurationCommandTreeBuilder class >> displayStrategy [
	^CmUIDisplayAsSubMenu 
]

{ #category : #accessing }
StDebuggerConfigurationCommandTreeBuilder class >> groupDescription [
	^ 'Debugger configuration actions'
]

{ #category : #accessing }
StDebuggerConfigurationCommandTreeBuilder class >> groupName [ 	
	^'Debugger configuration'
]

{ #category : #building }
StDebuggerConfigurationCommandTreeBuilder >> buildDebuggerCommandGroup [

	^ self group
		  register: self generalConfigurationCommandsGroup;
		  yourself
]

{ #category : #'accessing - commands classes' }
StDebuggerConfigurationCommandTreeBuilder >> configurationCommandClasses [

	^ {
		  StDebuggerToggleFilterStackCommand.
		  StDebuggerSettingsCommand }
]

{ #category : #commands }
StDebuggerConfigurationCommandTreeBuilder >> generalConfigurationCommandsGroup [

	| group |
	group := (CmCommandGroup named: self generalConfigurationGroupName)
		         asSpecGroup.
	group beDisplayedAsSubMenu.
	group description: self generalConfigurationGroupDescription.
	self configurationCommandClasses do: [ :c |
		group register:
			(self buildSpecCommand: c forContext: stDebuggerInstance) ].
	^ group
]

{ #category : #accessing }
StDebuggerConfigurationCommandTreeBuilder >> generalConfigurationGroupDescription [

	^ 'General configuration options for the StDebugger'
]

{ #category : #accessing }
StDebuggerConfigurationCommandTreeBuilder >> generalConfigurationGroupName [

	^ 'General debugger configuration'
]
