Extension { #name : #GTMoldableDebugger }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
GTMoldableDebugger class >> debugSession: aDebugSession [
	
	self openOn: aDebugSession withFullView: true andNotification: nil
]

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
GTMoldableDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| debugger |
	debugger := self on: aDebugSession.
	aBool | aString isNil
		ifTrue: [ debugger openWithFullView ]
		ifFalse: [ debugger openWithNotification: aString ]	"In case the string is nil it means we should show the full debugger and not a notification"
]
