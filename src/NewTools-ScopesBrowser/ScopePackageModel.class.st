Class {
	#name : 'ScopePackageModel',
	#superclass : 'ScopeNodeModel',
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
ScopePackageModel >> definedClasses [
	^ node definedClasses
]

{ #category : 'as yet unclassified' }
ScopePackageModel >> isPackageNode [
	^ true
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
