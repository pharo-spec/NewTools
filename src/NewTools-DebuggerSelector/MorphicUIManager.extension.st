Extension { #name : #MorphicUIManager }

{ #category : #'*NewTools-DebuggerSelector' }
MorphicUIManager >> debugProcess: process context: context label: title fullView: bool notification: notificationString [
	"Open a notifier in response to an error, halt, or notify. A notifier view
	just shows a short view of the sender stack and provides a menu that
	lets the user open a full debugger."

	| debugSession |
	debugSession := process
		newDebugSessionNamed: title
		startedAt: context.
	self
		flag: 'The following commented line seems to block the image on DNU'.
	"DebugSessionStorage singleton storeDebugSession: debugSession."
	debugSession logStackToFileIfNeeded.
	debugSession isAboutUIProcess
		ifTrue:
			[ DefaultExecutionEnvironment beActiveDuring: [ self spawnNewProcess ] ].
	self
		defer: [ "schedule debugger in deferred UI message to address
			redraw problems after opening a debugger e.g. from
			the testrunner."
			[ DebuggerSelector singleton
				selectAndOpenDebuggerFor: debugSession
				withNotification: notificationString ]
				on: Error
				do: [ :ex | debugSession signalDebuggerError: ex ] ].
	process suspend
]

{ #category : #'*NewTools-DebuggerSelector' }
MorphicUIManager >> debugProcess: process level: debuggerLevel context: context label: title fullView: bool notification: notificationString [
	DebuggerSelector singleton
		debugProcess: process
		level: debuggerLevel
		context: context
		label: title
		fullView: bool
		notification: notificationString
		fromUIManager: self
]
