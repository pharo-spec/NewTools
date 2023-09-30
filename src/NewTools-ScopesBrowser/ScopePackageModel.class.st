Class {
	#name : 'ScopePackageModel',
	#superclass : 'ScopeNodeModel',
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
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

{ #category : 'testing' }
ScopePackageModel >> isPackageNode [
	^ true
]

{ #category : 'accessing' }
ScopePackageModel >> scopesIconName [
	^ #package
]
