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

{ #category : 'accessing - model' }
ScopeAbstractPresenter >> setModelBeforeInitialization: aDomainObject [

	model := aDomainObject
]
