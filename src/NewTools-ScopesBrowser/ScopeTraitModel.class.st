Class {
	#name : 'ScopeTraitModel',
	#superclass : 'ScopeNodeModel',
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
ScopeTraitModel >> children [

	^ #(  )
]

{ #category : 'accessing' }
ScopeTraitModel >> isClassOrTraitNode [
	^ true
]

{ #category : 'accessing' }
ScopeTraitModel >> scopesIconName [
	^ #trait
]
