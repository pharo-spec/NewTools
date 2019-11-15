"
I am a simple wrapper holding the current context and the current debug session in a debugger.
My purpose is only to display context and debug session related information in the debugger inspector.
"
Class {
	#name : #StDebuggerContext,
	#superclass : #Object,
	#instVars : [
		'context',
		'session'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerContext class >> context: aContext session: aDebugSession [
	^ self new
		context: aContext;
		session: aDebugSession;
		yourself
]

{ #category : #accessing }
StDebuggerContext >> allInspectorNodes [
	^ {(StDebuggerContextInspectorReceiverNode hostObject: self).
	(StDebuggerContextInspectorTempsNode hostObject: self).
	(StDebuggerContextInspectorContextNode hostObject: self)}
]

{ #category : #accessing }
StDebuggerContext >> context [
	^ context
]

{ #category : #accessing }
StDebuggerContext >> context: anObject [
	context := anObject
]

{ #category : #printing }
StDebuggerContext >> printOn: aStream [
	aStream nextPutAll: context asString 
]

{ #category : #accessing }
StDebuggerContext >> session [
	^ session
]

{ #category : #accessing }
StDebuggerContext >> session: anObject [
	session := anObject
]
