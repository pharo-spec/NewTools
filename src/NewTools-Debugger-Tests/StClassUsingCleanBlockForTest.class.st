Class {
	#name : 'StClassUsingCleanBlockForTest',
	#superclass : 'Object',
	#instVars : [
		'myVar'
	],
	#category : 'NewTools-Debugger-Tests-Utils',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Utils'
}

{ #category : 'initialization' }
StClassUsingCleanBlockForTest >> boom [

	| r |

	r := myVar yourself.

	^ self in: [ :e | 
		1 + 1 ].
	
]

{ #category : 'initialization' }
StClassUsingCleanBlockForTest >> initialize [ 
	
	super initialize.
	myVar := Object new.
]
