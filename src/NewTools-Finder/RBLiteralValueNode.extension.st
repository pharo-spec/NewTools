Extension { #name : 'RBLiteralValueNode' }

{ #category : '*NewTools-Finder' }
RBLiteralValueNode >> evaluateForReceiver: aReceiver withTimeout: anInteger [ 
	"evaluate the AST binding self to the receiver and taking its variables"

	^ value
]
