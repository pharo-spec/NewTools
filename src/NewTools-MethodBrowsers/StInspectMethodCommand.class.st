"
Inspect selected method from a message browser list
"
Class {
	#name : 'StInspectMethodCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StInspectMethodCommand class >> defaultName [

	^ 'Inspect method'
]

{ #category : 'accessing' }
StInspectMethodCommand class >> defaultShortcut [

	^ $i actionModifier
]

{ #category : 'executing' }
StInspectMethodCommand >> execute [
	
	context doInspectMethod
]
