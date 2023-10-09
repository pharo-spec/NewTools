Class {
	#name : 'ScopeClassNode',
	#superclass : 'ScopeNode',
	#category : 'NewTools-Scopes-Browser-Nodes',
	#package : 'NewTools-Scopes-Browser',
	#tag : 'Nodes'
}

{ #category : 'accessing' }
ScopeClassNode >> children [

	^ #(  )
]

{ #category : 'accessing' }
ScopeClassNode >> isClassOrTraitNode [
	^ true
]

{ #category : 'accessing' }
ScopeClassNode >> scopesIconName [
	^ #class
]
