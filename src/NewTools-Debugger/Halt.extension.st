Extension { #name : #Halt }

{ #category : #'*NewTools-Debugger' }
Halt >> description [
	(self signalContext receiver isKindOf: Exception) 
		& (self signalContext selector = #signal) ifTrue: [ ^ 'Halt' ].
	^ 'Halt in ', self signalContext asString.
]
