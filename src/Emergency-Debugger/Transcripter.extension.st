Extension { #name : #Transcripter }

{ #category : #'*Emergency-Debugger' }
Transcripter classSide >> debugError: anError fromSession: aDebugSession [
	"The emergency evaluator does not know how to use a debug session, so it is dropped"

	self
		primitiveError:
			'Original error: ' , name asString
				,
					'.
	Smalltalk tools debugger error: '
				,
					([ anError description ]
						on: Error
						do: [ 'a ' , anError class printString ]) , ':'
]
