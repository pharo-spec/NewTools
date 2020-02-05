Extension { #name : #SpecDebugger }

{ #category : #'*NewTools-Sindarin-Tools' }
SpecDebugger >> sindarinDebugger [
	^ self
		extensionToolNamed: SindarinDebugger debuggerExtensionKey
		ifAbsent: [ self registerExtensionTool: (SindarinDebugger attachTo: self session) ]
]
