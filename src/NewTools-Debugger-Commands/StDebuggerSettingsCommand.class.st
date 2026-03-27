"
I open a settings browser focused on the debugger and debugging systems settings.
"
Class {
	#name : 'StDebuggerSettingsCommand',
	#superclass : 'StDebuggerCommand',
	#category : 'NewTools-Debugger-Commands',
	#package : 'NewTools-Debugger-Commands'
}

{ #category : 'default' }
StDebuggerSettingsCommand class >> defaultDescription [
	^'I open a settings browser focused on the debugger and debugging systems settings.'
]

{ #category : 'initialization' }
StDebuggerSettingsCommand class >> defaultIconName [
	^ #configuration
]

{ #category : 'default' }
StDebuggerSettingsCommand class >> defaultName [ 
	^'Settings'
]

{ #category : 'initialization' }
StDebuggerSettingsCommand class >> defaultShortcut [
	^$f meta, $s meta
]

{ #category : 'accessing' }
StDebuggerSettingsCommand >> canBeExecuted [

	^ true
]

{ #category : 'executing' }
StDebuggerSettingsCommand >> execute [

	(StSettingsBrowser newApplication: self context application)
		selectPath: #(tools debugging);
		open
]
