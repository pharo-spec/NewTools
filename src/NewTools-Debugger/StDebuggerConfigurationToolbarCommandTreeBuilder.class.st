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

	| group |
	self group.
	group := self group.
	self configurationCommands do: [ :specCommand |
		group register: specCommand ].
	^ group
]

{ #category : #'accessing - commands classes' }
StDebuggerConfigurationToolbarCommandTreeBuilder >> configurationCommandClasses [

	^ {
		  StDebuggerToggleFilterStackCommand.
		  StDebuggerSettingsCommand }
]

{ #category : #commands }
StDebuggerConfigurationToolbarCommandTreeBuilder >> configurationCommands [

	^ self configurationCommandClasses collect: [ :c |
		  self buildSpecCommand: c forContext: stDebuggerInstance ]
]
