Extension { #name : 'OCLiteralValueNode' }

{ #category : '*NewTools-Finder' }
OCLiteralValueNode >> evaluateForReceiver: aReceiver withTimeout: anInteger [ 
	"evaluate the AST binding self to the receiver and taking its variables"

	^ value
]
