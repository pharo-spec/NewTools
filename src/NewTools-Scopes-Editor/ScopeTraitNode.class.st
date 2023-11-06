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

{ #category : 'as yet unclassified' }
ScopeTraitNode >> packageNode [
	
	^ ScopePackageNode on: self package
]

{ #category : 'accessing' }
ScopeTraitNode >> scopesIconName [
	^ #trait
]
