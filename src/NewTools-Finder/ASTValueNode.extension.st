Extension { #name : 'ASTValueNode' }

{ #category : '*NewTools-Finder' }
ASTValueNode >> evaluateForReceiver: aReceiver withTimeout: anInteger [ 
	"evaluate the AST binding self to the receiver and taking its variables"

	^ aReceiver class compiler
		ast: self asDoit;
		receiver: aReceiver;
		logged: false;
		evaluateWithTimeOut: anInteger
]

{ #category : '*NewTools-Finder' }
ASTValueNode >> evaluateWithTimeOut: anInteger [
	"evaluate the AST with a nil  receiver"
	
	^ self 
		evaluateForReceiver: nil 
		withTimeout: anInteger
]
