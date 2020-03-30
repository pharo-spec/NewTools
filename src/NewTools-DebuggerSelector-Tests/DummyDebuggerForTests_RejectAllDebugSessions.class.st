Class {
	#name : #'DummyDebuggerForTests_RejectAllDebugSessions',
	#superclass : #AbstractDebugger,
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'debugger declaration' }
DummyDebuggerForTests_RejectAllDebugSessions class >> iAmADebugger [
	<iAmADebugger>
	<iAmADummyDebuggerForTest>
	
]

{ #category : #'debugger declaration' }
DummyDebuggerForTests_RejectAllDebugSessions class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	"This method will be called to open this debugger on a given debug session (i.e. execution to debug). If this debugger wants to keep the debug session (and its process) alive (for example because it is a graphical debugger that would break if the debug session is terminated while its window is open), it should call #keepAlive: on @aDebugSession, passing itself as argument.
	The contract is that if a debugger calls #keepAlive:, it should also call #stopKeepingAlive: on @aDebugSession when it closes (passing itself as argument again).
	The debug session will automatically not be kept alive by this debugger anymore if this debugger gets garbage collected (and DebugSession will only hold a weak reference to this debugger, so it will not prevent its garbage collection)"

	"Do nothing"

	
]
