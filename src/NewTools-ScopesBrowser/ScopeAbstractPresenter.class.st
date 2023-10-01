Class {
	#name : 'ScopeAbstractPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model'
	],
	#category : 'NewTools-ScopesBrowser-GUI',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'GUI'
}

{ #category : 'accessing' }
ScopeAbstractPresenter >> announcer [
	^ model announcer
]

{ #category : 'accessing - model' }
ScopeAbstractPresenter >> setModelBeforeInitialization: aDomainObject [

	model := aDomainObject
]
