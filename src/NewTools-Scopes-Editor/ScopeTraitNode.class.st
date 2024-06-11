"
I am wrapper for traits to be used in the ScopeNodesTree
"
Class {
	#name : 'ScopeTraitNode',
	#superclass : 'ScopeNode',
	#category : 'NewTools-Scopes-Editor-Nodes',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'Nodes'
}

{ #category : 'accessing' }
ScopeTraitNode >> children [

	^ #(  )
]

{ #category : 'accessing' }
ScopeTraitNode >> isClassOrTraitNode [
	^ true
]

{ #category : 'accessing' }
ScopeTraitNode >> packageNode [
	
	^ ScopePackageNode on: self package
]

{ #category : 'accessing' }
ScopeTraitNode >> scopesIconName [
	^ #trait
]
