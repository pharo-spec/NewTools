Extension { #name : 'OCValueNode' }

{ #category : '*NewTools-Finder' }
OCValueNode >> evaluateForReceiver: aReceiver withTimeout: anInteger [ 
	"evaluate the AST binding self to the receiver and taking its variables"

	^ aReceiver class compiler
		ast: self asDoit;
		receiver: aReceiver;
		logged: false;
		evaluateWithTimeOut: anInteger
]

{ #category : '*NewTools-Finder' }
OCValueNode >> evaluateWithTimeOut: anInteger [
	"evaluate the AST with a nil  receiver"
	
	^ self 
		evaluateForReceiver: nil 
		withTimeout: anInteger
]
