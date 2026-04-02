"
Run the test case selected from a message browser list
"
Class {
	#name : 'StRunMethodTestCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'default' }
StRunMethodTestCommand class >> defaultName [

	^ 'Run test'
]

{ #category : 'accessing' }
StRunMethodTestCommand class >> defaultShortcut [

	^ $t actionModifier
]
