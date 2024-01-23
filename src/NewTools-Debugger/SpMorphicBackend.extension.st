Extension { #name : 'SpMorphicBackend' }

{ #category : '*NewTools-Debugger' }
SpMorphicBackend >> spawnNewDebugSessionForSpecBackend: aDebugSession [

	^ (StMorphicDebugSession newFromSession: aDebugSession)
		  backend: self;
		  yourself 
]
