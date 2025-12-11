Class {
	#name : 'StDebuggeClientModelAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'debuggerActionModel'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StDebuggeClientModelAnnouncement class >> debuggerClientModel: aDebuggerActionModel [

	^ self new debuggerClientModel: aDebuggerActionModel
]

{ #category : 'accessing' }
StDebuggeClientModelAnnouncement >> debuggerClientModel [

	^ debuggerActionModel
]

{ #category : 'accessing' }
StDebuggeClientModelAnnouncement >> debuggerClientModel: aDebuggerActionModel [

	debuggerActionModel := aDebuggerActionModel
]
