"
Inspect selected method from a message browser list
"
Class {
	#name : 'StMessageInspectMethodCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StMessageInspectMethodCommand class >> defaultName [

	^ 'Inspect method'
]

{ #category : 'accessing' }
StMessageInspectMethodCommand class >> defaultShortcut [

	^ $i actionModifier
]

{ #category : 'executing' }
StMessageInspectMethodCommand >> execute [
	
	context doInspectMethod
]
