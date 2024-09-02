Extension { #name : 'ASTLiteralValueNode' }

{ #category : '*NewTools-Finder' }
ASTLiteralValueNode >> evaluateForReceiver: aReceiver withTimeout: anInteger [ 
	"evaluate the AST binding self to the receiver and taking its variables"

	^ value
]
