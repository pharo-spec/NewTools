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

	| className class package |
	^ self value basisObjects collect: [ :stringOrPackage |
		  stringOrPackage isString
			  ifTrue: [
				  className := stringOrPackage.
				  class := self systemDictionary at: className ifAbsent: [ nil ].
				  ScopeClassNode on: class ]
			  ifFalse: [
				  package := stringOrPackage.
				  ScopePackageNode on: package ] ]
]

{ #category : 'testing' }
ScopeScopeNode >> isScopeNode [
	^ true
]

{ #category : 'accessing' }
ScopeScopeNode >> label [
	^ self value label
]

{ #category : 'accessing' }
ScopeScopeNode >> scopesIconName [
	^ #references
]

{ #category : 'accessing' }
ScopeScopeNode >> systemDictionary [
	^ Smalltalk globals
]
