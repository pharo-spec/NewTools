Class {
	#name : 'ScopePackageModel',
	#superclass : 'ScopeNodeModel',
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'as yet unclassified' }
ScopePackageModel >> children [

	^ value definedClasses asOrderedCollection collect: [ :classOrTrait |
		  classOrTrait isClassOrTrait ifFalse: [
			  self error: 'child must be a class or a trait' ].
		  classOrTrait isTrait
			  ifTrue: [ ScopeTraitModel on: classOrTrait ]
			  ifFalse: [ ScopeClassModel on: classOrTrait ] ]
]

{ #category : 'accessing' }
ScopePackageModel >> definedClasses [
	^ value definedClasses
]

{ #category : 'as yet unclassified' }
ScopePackageModel >> isPackageNode [
	^ true
]

{ #category : 'as yet unclassified' }
ScopePackageModel >> scopesIconName [
	^ #package
]
