"
I am a model for having scopes in the ScopeTreePresenter
"
Class {
	#name : 'ScopeScopeNode',
	#superclass : 'ScopeNode',
	#category : 'NewTools-Scopes-Browser-Nodes',
	#package : 'NewTools-Scopes-Browser',
	#tag : 'Nodes'
}

{ #category : 'accessing' }
ScopeScopeNode >> children [

	^ self value basisObjects collect: [ :package |
		  ScopePackageNode on: package ]
]

{ #category : 'accessing' }
ScopeScopeNode >> label [
	^ self value label
]

{ #category : 'accessing' }
ScopeScopeNode >> scopesIconName [
	^ #references
]
