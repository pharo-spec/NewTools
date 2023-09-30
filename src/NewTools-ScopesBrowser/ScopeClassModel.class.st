Class {
	#name : 'ScopeClassModel',
	#superclass : 'ScopeNodeModel',
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
ScopeClassModel >> children [

	^ #(  )
]

{ #category : 'accessing' }
ScopeClassModel >> isClassOrTraitNode [
	^ true
]

{ #category : 'accessing' }
ScopeClassModel >> scopesIconName [
	^ #class
]
