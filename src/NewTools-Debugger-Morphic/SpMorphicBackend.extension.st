Extension { #name : 'SpMorphicBackend' }

{ #category : '*NewTools-Debugger-Morphic' }
SpMorphicBackend >> spawnNewDebugSessionForSpecBackend: aDebugSession [

	^ (StMorphicDebugSession newFromSession: aDebugSession)
		  backend: self;
		  yourself 
]
