Class {
	#name : #StDebuggerActionModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'debuggerActionModel'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerActionModelAnnouncement class >> debuggerActionModel: aDebuggerActionModel [

	^ self new debuggerActionModel: aDebuggerActionModel
]

{ #category : #accessing }
StDebuggerActionModelAnnouncement >> debuggerActionModel [

	^ debuggerActionModel
]

{ #category : #accessing }
StDebuggerActionModelAnnouncement >> debuggerActionModel: aDebuggerActionModel [

	debuggerActionModel := aDebuggerActionModel
]
