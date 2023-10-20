"
I allow to easily create trees (instances of ScopeTreePresenter) to display scopes (as roots) and scopes (as roots)
"
Class {
	#name : 'ScopeAbstractPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model'
	],
	#category : 'NewTools-Scopes-Browser-GUI',
	#package : 'NewTools-Scopes-Browser',
	#tag : 'GUI'
}

{ #category : 'accessing' }
ScopeAbstractPresenter >> announcer [ 
	^ model announcer
]

{ #category : 'private - presenters' }
ScopeAbstractPresenter >> newScopeTree [

	^ self instantiate: ScopeTreePresenter
]

{ #category : 'private - presenters' }
ScopeAbstractPresenter >> setModelBeforeInitialization: aScopesManager [

	model := aScopesManager 
]
