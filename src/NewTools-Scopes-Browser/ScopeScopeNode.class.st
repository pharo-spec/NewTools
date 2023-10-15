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

	| className class package orphanClasses fullPackages envPackages envClasses children packageEnvironments classesEnvironments |
	self value isCompositeEnvironment ifTrue: [
		children := Set new.
		envPackages := self value packages.
		envClasses := self value classes.
		"classes whose package hasn't all of its classes selected"
		orphanClasses := envClasses select: [ :each |
			                 | siblings |
			                 siblings := each package definedClasses.
			                 siblings anySatisfy: [ :sibling |
				                 envClasses noneSatisfy: [ :selectedClass |
					                 selectedClass = sibling ] ] ].

		"packages whose classes were all selected"
		fullPackages := envPackages select: [ :each |
			                each definedClasses noneSatisfy: [ :each1 |
				                orphanClasses anySatisfy: [ :orphan |
					                orphan = each1 ] ] ].

		packageEnvironments := fullPackages collect: [ :thePackage |
			                       ScopePackageNode on: thePackage ].
		classesEnvironments := orphanClasses collect: [ :theClass |
			                       theClass isTrait
				                       ifTrue: [ ScopeTraitNode on: theClass ]
				                       ifFalse: [ ScopeClassNode on: theClass ] ].
		packageEnvironments do: [ :env | children add: env ].
		classesEnvironments do: [ :env | children add: env ].
		^ children ].

	^ self value basisObjects collect: [ :stringOrPackage |
		  stringOrPackage isString
			  ifTrue: [
				  className := stringOrPackage.
				  class := self systemDictionary at: className ifAbsent: [ nil ].
				  class isTrait
					  ifTrue: [ ScopeTraitNode on: class ]
					  ifFalse: [ ScopeClassNode on: class ] ]
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
	^ #smallPushpin
]

{ #category : 'accessing' }
ScopeScopeNode >> systemDictionary [
	^ Smalltalk globals
]
