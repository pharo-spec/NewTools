Extension { #name : #SpPresenter }

{ #category : #'*NewTools-Debugger-Extensions' }
SpPresenter >> newDynamicToolbar [
	self flag: 'Move to SpPresenter.'.
	^ self instantiate: SpDynamicToolbarPresenter 
]
