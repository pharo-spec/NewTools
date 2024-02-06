"
Command to debug a resulting expression from the Examples search mode in the Finder tool

"
Class {
	#name : 'StFinderDebugItCommand',
	#superclass : 'StFinderExecutionCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderDebugItCommand class >> defaultDescription [

	^ 'Debug the selected example'
]

{ #category : 'initialization' }
StFinderDebugItCommand class >> defaultIconName [

	^ #smallDebugIt
]

{ #category : 'default' }
StFinderDebugItCommand class >> defaultName [ 

	^ 'Debug It'
]

{ #category : 'initialization' }
StFinderDebugItCommand class >> defaultShortcut [

	^ $d meta
]

{ #category : 'executing' }
StFinderDebugItCommand >> execute [
	"Debug the selected example result"

	self selectedItem content debug

]
