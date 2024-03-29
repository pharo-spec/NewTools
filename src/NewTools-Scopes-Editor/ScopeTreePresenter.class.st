"
I am a tree visualization who toggles on double click
"
Class {
	#name : 'ScopeTreePresenter',
	#superclass : 'SpTreeTablePresenter',
	#category : 'NewTools-Scopes-Editor-GUI',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'GUI'
}

{ #category : 'api' }
ScopeTreePresenter >> collapseSelectedItems [
	self selection selectedPaths do: [ :path | self collapsePath: path ]
]

{ #category : 'api' }
ScopeTreePresenter >> expandSelectedItems [
	self selection selectedPaths do: [ :path | self expandPath: path ]
]

{ #category : 'api' }
ScopeTreePresenter >> togglePath: aPath [
	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter togglePath: aPath ]
]

{ #category : 'api' }
ScopeTreePresenter >> toggleSelectedItems [
	self selection selectedPaths do: [ :path | self togglePath: path ]
]
