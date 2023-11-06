Class {
	#name : 'ScopePackageNode',
	#superclass : 'ScopeNode',
	#category : 'NewTools-Scopes-Editor-Nodes',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'Nodes'
}

{ #category : 'accessing' }
ScopePackageNode >> children [

	^ value definedClasses asOrderedCollection collect: [ :classOrTrait |
		  classOrTrait isClassOrTrait ifFalse: [
			  self error: 'child must be a class or a trait' ].
		  classOrTrait isTrait
			  ifTrue: [ ScopeTraitNode on: classOrTrait ]
			  ifFalse: [ ScopeClassNode on: classOrTrait ] ]
]

{ #category : 'accessing' }
ScopePackageNode >> definedClasses [
	^ value definedClasses
]

{ #category : 'testing' }
ScopePackageNode >> isPackageNode [
	^ true
]

{ #category : 'testing' }
ScopePackageNode >> isScopeNode [
	^ false
]

{ #category : 'as yet unclassified' }
ScopePackageNode >> packageNode [
	^ self
]

{ #category : 'accessing' }
ScopePackageNode >> scopesIconName [
	^ #package
]
