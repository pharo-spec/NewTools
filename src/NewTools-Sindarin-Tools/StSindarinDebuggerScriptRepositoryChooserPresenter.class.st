Class {
	#name : 'StSindarinDebuggerScriptRepositoryChooserPresenter',
	#superclass : 'SpDropListPresenter',
	#category : 'NewTools-Sindarin-Tools-Presenters',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Presenters'
}

{ #category : 'api' }
StSindarinDebuggerScriptRepositoryChooserPresenter >> display [

	^ [ :e | e repositoryName ]
]

{ #category : 'initialization' }
StSindarinDebuggerScriptRepositoryChooserPresenter >> findRepositories [

	self items: StSindarinDebuggerScriptRepositoryAbstract subclasses
]

{ #category : 'actions' }
StSindarinDebuggerScriptRepositoryChooserPresenter >> loadScript: aString [

	^ self selectedItem loadScript: aString
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepositoryChooserPresenter >> saveScript: aStringKey code: aStringValue [

	self selectedItem saveScript: aStringKey code: aStringValue
]
