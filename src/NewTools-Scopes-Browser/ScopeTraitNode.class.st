Class {
	#name : 'ScopeTraitNode',
	#superclass : 'ScopeNode',
	#category : 'NewTools-Scopes-Browser-Nodes',
	#package : 'NewTools-Scopes-Browser',
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
ScopeTraitNode >> scopesIconName [
	^ #trait
]
