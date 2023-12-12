"
I am wrapper for classes to be used in the ScopeNodesTree
"
Class {
	#name : 'ScopeClassNode',
	#superclass : 'ScopeNode',
	#category : 'NewTools-Scopes-Editor-Nodes',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'Nodes'
}

{ #category : 'accessing' }
ScopeClassNode >> children [

	^  #(  )
]

{ #category : 'testing' }
ScopeClassNode >> isClassNode [
	^ true
]

{ #category : 'accessing' }
ScopeClassNode >> isClassOrTraitNode [
	^ true
]

{ #category : 'accessing' }
ScopeClassNode >> packageNode [

	^ ScopePackageNode on: self package
]

{ #category : 'accessing' }
ScopeClassNode >> scopesIconName [
	^ #class
]
