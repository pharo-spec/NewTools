Class {
	#name : 'ScopeClassModel',
	#superclass : 'ScopeNodeModel',
	#category : 'NewTools-ScopesBrowser-Models',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Models'
}

{ #category : 'accessing' }
ScopeClassModel >> isClassNode [
	^ true
]

{ #category : 'accessing' }
ScopeClassModel >> scopesIconName [
	^ #class
]

{ #category : 'accessing' }
ScopeClassModel >> subelements [

	^ #(  )
]
