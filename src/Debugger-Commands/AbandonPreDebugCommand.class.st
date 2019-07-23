Class {
	#name : #AbandonPreDebugCommand,
	#superclass : #PreDebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #default }
AbandonPreDebugCommand class >> defaultCommandName [
	<PreDebugCommand>
	^ 'Abandon'
]

{ #category : #default }
AbandonPreDebugCommand class >> defaultDescription [
	^ 'Close the debugger and ignore the exception'
]

{ #category : #initialization }
AbandonPreDebugCommand class >> defaultIconName [
	^  #delete
]

{ #category : #initialization }
AbandonPreDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #hooks }
AbandonPreDebugCommand >> execute [
	self preDebugWindow close
]
