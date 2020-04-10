"
I'm a ""do it and inspect"" command.
I will select all contents of a playground and I will execute it, inspecting the result.
"
Class {
	#name : #StPlaygroundDoItCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #converting }
StPlaygroundDoItCommand >> asSpecCommand [ 
	
	^ super asSpecCommand 
		iconName: #glamorousGo;
		yourself
]

{ #category : #execution }
StPlaygroundDoItCommand >> execute [ 

	self selectAll.
	(SpCodeInspectItCommand forContext: context) execute
]

{ #category : #initialization }
StPlaygroundDoItCommand >> initialize [
	super initialize.
	self
		name: 'Do it';
		description: 'Do it all and inspect.'
]

{ #category : #execution }
StPlaygroundDoItCommand >> selectAll [
	
	context selectAll
]
