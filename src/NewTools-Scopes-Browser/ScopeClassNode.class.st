Class {
	#name : 'ScopeClassNode',
	#superclass : 'ScopeNode',
	#category : 'NewTools-Scopes-Browser-Nodes',
	#package : 'NewTools-Scopes-Browser',
	#tag : 'Nodes'
}

{ #category : 'accessing' }
ScopeClassNode >> children [

	^ children ifNil: [children := #(  )]
]

{ #category : 'testing' }
ScopeClassNode >> isClassNode [
	^ true
]

{ #category : 'accessing' }
ScopeClassNode >> isClassOrTraitNode [
	^ true
]

{ #category : 'as yet unclassified' }
ScopeClassNode >> packageNode [

	^ ScopePackageNode on: self package
]

{ #category : 'accessing' }
ScopeClassNode >> scopesIconName [
	^ #class
]
