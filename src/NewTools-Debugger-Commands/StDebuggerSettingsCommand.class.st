"
I open a settings browser focused on the debugger and debugging systems settings.
"
Class {
	#name : #StDebuggerSettingsCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
StDebuggerSettingsCommand class >> defaultDescription [
	^'I open a settings browser focused on the debugger and debugging systems settings.'
]

{ #category : #default }
StDebuggerSettingsCommand class >> defaultName [ 
	^'Settings'
]

{ #category : #executing }
StDebuggerSettingsCommand >> execute [

	SettingBrowser new
		rootNodes:
			(SettingBrowser currentTree nodeNamed: #debugging) allChildren;
		open
]
