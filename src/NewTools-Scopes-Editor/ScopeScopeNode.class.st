"
I am a model for having scopes in the ScopeTreePresenter
"
Class {
	#name : 'ScopeScopeNode',
	#superclass : 'ScopeNode',
	#category : 'NewTools-Scopes-Editor-Nodes',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'Nodes'
}

{ #category : 'accessing' }
ScopeScopeNode >> children [

	| fullPackages orphanClasses packageChildren classChildren |
	
	fullPackages := self value fullPackages.
	orphanClasses := self value orphanClasses.

	packageChildren := fullPackages collect: [ :package |
		                   ScopePackageNode on: package ].
	classChildren := orphanClasses collect: [ :class |
		                 class isTrait
			                 ifTrue: [ ScopeTraitNode on: class ]
			                 ifFalse: [ ScopeClassNode on: class ] ].

	^ packageChildren asOrderedCollection 
		  addAll: classChildren;
		  yourself
]

{ #category : 'accessing' }
ScopeScopeNode >> classes [

	^ value classes
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
ScopeScopeNode >> packageNode [
	^ self shouldNotImplement 
]

{ #category : 'accessing' }
ScopeScopeNode >> packages [

	^ value packages
]

{ #category : 'accessing' }
ScopeScopeNode >> scopesIconName [
	^ #smallPushpin
]

{ #category : 'accessing' }
ScopeScopeNode >> systemDictionary [
	^ Smalltalk globals
]
