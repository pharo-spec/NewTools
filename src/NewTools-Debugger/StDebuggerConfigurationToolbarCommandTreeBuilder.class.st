Class {
	#name : #StDebuggerConfigurationToolbarCommandTreeBuilder,
	#superclass : #StDebuggerCommandTreeBuilder,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerConfigurationToolbarCommandTreeBuilder class >> displayStrategy [
	^CmUIDisplayAsGroup
]

{ #category : #accessing }
StDebuggerConfigurationToolbarCommandTreeBuilder class >> groupDescription [
	^ 'Debugger configuration actions'
]

{ #category : #accessing }
StDebuggerConfigurationToolbarCommandTreeBuilder class >> groupName [ 	
	^'Configuration'
]

{ #category : #building }
StDebuggerConfigurationToolbarCommandTreeBuilder >> buildDebuggerCommandGroup [

	^ self group
		  register: self generalConfigurationCommandsGroup;
		  yourself
]

{ #category : #'accessing - commands classes' }
StDebuggerConfigurationToolbarCommandTreeBuilder >> configurationCommandClasses [

	^ {
		  StDebuggerToggleFilterStackCommand.
		  StDebuggerSettingsCommand }
]

{ #category : #commands }
StDebuggerConfigurationToolbarCommandTreeBuilder >> generalConfigurationCommandsGroup [

	| group |
	group := (CmCommandGroup named: self generalConfigurationGroupName)
		         asSpecGroup.
	group beDisplayedAsGroup.
	group description: self generalConfigurationGroupDescription.
	self configurationCommandClasses do: [ :c |
		group register:
			(self buildSpecCommand: c forContext: stDebuggerInstance) ].
	^ group
]

{ #category : #accessing }
StDebuggerConfigurationToolbarCommandTreeBuilder >> generalConfigurationGroupDescription [
	^'General configuration options for the StDebugger'
]

{ #category : #accessing }
StDebuggerConfigurationToolbarCommandTreeBuilder >> generalConfigurationGroupName [
	^'General cdebugger onfiguration'
]
