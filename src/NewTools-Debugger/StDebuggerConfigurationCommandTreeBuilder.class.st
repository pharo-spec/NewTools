"
I build the default command tree for the debugger configuration.
The command classes I instantiate are specified under the ""accessing - commands classes"" protocol.
The group names and descriptions are specified under the ""accessing"" protocol.

You can modify the default groups names and descriptions and the default commands by modifying my code, but I am not meant to be extended through subclassing. 
As I provide the **default** debugger commands, you should only extend me by using the Spec extension mechanism and not by subclassing me.
Using me to add command in the tree makes them default for the debugger configuration.
"
Class {
	#name : 'StDebuggerConfigurationCommandTreeBuilder',
	#superclass : 'StDebuggerCommandTreeBuilder',
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'accessing' }
StDebuggerConfigurationCommandTreeBuilder class >> displayStrategy [
	^CmUIDisplayAsSubMenu 
]

{ #category : 'accessing' }
StDebuggerConfigurationCommandTreeBuilder class >> groupDescription [
	^ 'Debugger configuration actions'
]

{ #category : 'accessing' }
StDebuggerConfigurationCommandTreeBuilder class >> groupName [ 	
	^'Debugger configuration'
]

{ #category : 'building' }
StDebuggerConfigurationCommandTreeBuilder >> buildDebuggerCommandGroup [

	^ self group
		  register: self generalConfigurationCommandsGroup;
		  yourself
]

{ #category : 'accessing - commands classes' }
StDebuggerConfigurationCommandTreeBuilder >> configurationCommandClasses [

	^ {
		  StDebuggerExtensionSettingsCommand.
		  StDebuggerToggleFilterStackCommand.
		  StDebuggerSettingsCommand }
]

{ #category : 'commands' }
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

{ #category : 'accessing' }
StDebuggerConfigurationCommandTreeBuilder >> generalConfigurationGroupDescription [

	^ 'General configuration options for the StDebugger'
]

{ #category : 'accessing' }
StDebuggerConfigurationCommandTreeBuilder >> generalConfigurationGroupName [

	^ 'General debugger configuration'
]
