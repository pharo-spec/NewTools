"
I'm a tree node representing a method implementation
"
Class {
	#name : 'StMethodImplementationNode',
	#superclass : 'StMethodDependencyNode',
	#category : 'NewTools-DependencyAnalyser-UI-Nodes',
	#package : 'NewTools-DependencyAnalyser-UI',
	#tag : 'Nodes'
}

{ #category : 'accessing' }
StMethodImplementationNode >> icon [
	^ self iconNamed: #package
]

{ #category : 'testing' }
StMethodImplementationNode >> isMethodImplementationNode [

	^ true
]

{ #category : 'displaying' }
StMethodImplementationNode >> label [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'Implemented in ';
			nextPutAll: self content package name;
			nextPutAll: ': #';
			nextPutAll: self content methodClass name ]
]
