"
I open a table to activate or unactivate debugger extensions
"
Class {
	#name : 'StDebuggerExtensionSettingsCommand',
	#superclass : 'StDebuggerCommand',
	#category : 'NewTools-Debugger-Commands',
	#package : 'NewTools-Debugger-Commands'
}

{ #category : 'default' }
StDebuggerExtensionSettingsCommand class >> defaultDescription [

	^ 'I open a table in a popover that allows to activate or unactivate any debugger extension'
]

{ #category : 'initialization' }
StDebuggerExtensionSettingsCommand class >> defaultIconName [

	^ #config
]

{ #category : 'default' }
StDebuggerExtensionSettingsCommand class >> defaultName [

	^ 'Extension settings'
]

{ #category : 'initialization' }
StDebuggerExtensionSettingsCommand class >> defaultShortcut [

	^ nil
]

{ #category : 'executing' }
StDebuggerExtensionSettingsCommand >> execute [

	| settings |
	settings := StDebuggerExtensionSettingsPresenter new.
	self context newPopover
		bePositionLeft;
		presenter: settings;
		relativeTo: self context stackHeader toolbar;
		popup
]
