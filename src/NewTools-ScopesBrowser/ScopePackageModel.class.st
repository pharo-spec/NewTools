Class {
	#name : 'ScopePackageModel',
	#superclass : 'ScopeNodeModel',
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'as yet unclassified' }
ScopePackageModel >> package [
	^ self
]

{ #category : 'as yet unclassified' }
ScopePackageModel >> scopesIconName [
	^ #package
]

{ #category : 'as yet unclassified' }
ScopePackageModel >> subelements [

	^ node definedClasses asOrderedCollection collect: [ :classOrTrait |
		  classOrTrait isTrait
			  ifTrue: [ ScopeTraitModel on: classOrTrait ]
			  ifFalse: [ ScopeClassModel on: classOrTrait ] ]
]
