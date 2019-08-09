Extension { #name : #SindarinDebugger }

{ #category : #'*NewTools-Sindarin-Tools' }
SindarinDebugger >> sindarinDebuggerInspection [
	<inspectorPresentationOrder: -10 title: 'Sindarin'>

	^ StSindarinDebuggerPresenter on: self
]
