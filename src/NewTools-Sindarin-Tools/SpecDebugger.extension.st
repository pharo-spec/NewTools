Extension { #name : #SpecDebugger }

{ #category : #'*NewTools-Sindarin-Tools' }
SpecDebugger >> sindarinDebugger [
	^ SindarinDebugger attachTo: self session
]
