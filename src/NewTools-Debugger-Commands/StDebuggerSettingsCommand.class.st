"
I open a settings browser focused on the debugger and debugging systems settings.
"
Class {
	#name : #StDebuggerSettingsCommand,
	#superclass : #StDebuggerCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #default }
StDebuggerSettingsCommand class >> defaultDescription [
	^'I open a settings browser focused on the debugger and debugging systems settings.'
]

{ #category : #initialization }
StDebuggerSettingsCommand class >> defaultIconName [
	^ #configuration
]

{ #category : #default }
StDebuggerSettingsCommand class >> defaultName [ 
	^'Settings'
]

{ #category : #initialization }
StDebuggerSettingsCommand class >> defaultShortcut [
	^$f meta + $s 
]

{ #category : #executing }
StDebuggerSettingsCommand >> execute [
	| regexpSearch browser window path |
	regexpSearch := SettingBrowser regexpSearch.
	SettingBrowser regexpSearch: true.
	
	browser := SettingBrowser new 
		changeSearchedText: 'Debugging';
		yourself.
		 
	window := browser open.
	path := (window submorphs detect: [ :each | (each isKindOf: MorphTreeMorph)  ]) nodeList.
	browser expandNodePath: path first contents first contents first path.
	SettingBrowser regexpSearch: regexpSearch
]
