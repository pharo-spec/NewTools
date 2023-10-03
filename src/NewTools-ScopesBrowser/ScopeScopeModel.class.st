"
I am a model for having scopes in the ScopeTreePresenter
"
Class {
	#name : 'ScopeScopeModel',
	#superclass : 'ScopeNodeModel',
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
ScopeScopeModel >> children [

	^ self value basisObjects collect: [ :package |
		  ScopePackageModel on: package ]
]

{ #category : 'accessing' }
ScopeScopeModel >> label [
	^ self value label
]

{ #category : 'accessing' }
ScopeScopeModel >> scopesIconName [
	^ #references
]
