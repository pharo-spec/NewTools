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

	| className class package orphanClasses fullPackages envPackages envClasses chldrn packageEnvironments classesEnvironments |

	children ifNotNil: [ ^ children ].

	self value isCompositeEnvironment ifTrue: [
		chldrn := Set new.
		envPackages := self value packages.
		envClasses := self value classes reject: [:c | c isMeta ].

		"packages whose classes were all selected"
		fullPackages := ScopesManager
			                fullPackagesIn: envPackages
			                having: envClasses.
		"classes whose package hasn't all of its classes selected"

		orphanClasses := ScopesManager
			                 orphanClassesIn: envClasses
			                 havingPackages: envPackages
			                 fullPackages: fullPackages.

		packageEnvironments := fullPackages collect: [ :thePackage |
			                       ScopePackageNode on: thePackage ].
		classesEnvironments := orphanClasses collect: [ :theClass |
			                       theClass isTrait
				                       ifTrue: [ ScopeTraitNode on: theClass ]
				                       ifFalse: [ ScopeClassNode on: theClass ] ].
		packageEnvironments do: [ :env | chldrn add: env ].
		classesEnvironments do: [ :env | chldrn add: env ].
		^ children := chldrn ].

	^ children := self value basisObjects collect: [ :stringOrPackage |
		            stringOrPackage isString
			            ifTrue: [
				            className := stringOrPackage.
				            class := self systemDictionary
					                     at: className
					                     ifAbsent: [ nil ].
				            class isTrait
					            ifTrue: [ ScopeTraitNode on: class ]
					            ifFalse: [ ScopeClassNode on: class ] ]
			            ifFalse: [
				            stringOrPackage isClassOrTrait
					            ifTrue: [ ScopeClassNode on: stringOrPackage ]
					            ifFalse: [
						            self assert: (stringOrPackage isKindOf: RPackage).
						            package := stringOrPackage.
						            ScopePackageNode on: package ] ] ].

]

{ #category : 'testing' }
ScopeScopeNode >> isScopeNode [
	^ true
]

{ #category : 'accessing' }
ScopeScopeNode >> label [
	^ self value label
]

{ #category : 'as yet unclassified' }
ScopeScopeNode >> packageNode [
	self shouldNotImplement 
]

{ #category : 'accessing' }
ScopeScopeNode >> scopesIconName [
	^ #smallPushpin
]

{ #category : 'accessing' }
ScopeScopeNode >> systemDictionary [
	^ Smalltalk globals
]
