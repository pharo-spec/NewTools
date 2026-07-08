Class {
	#name : 'StComposedMethodListPresenter',
	#superclass : 'StMethodListPresenter',
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'initialization' }
StComposedMethodListPresenter >> initializePresenters [

	listPresenter := self newListView.
	listPresenter
		"sortingBlock: [ :a :b | self sortClassesInCachedHierarchy: a b: b ];"
		setup: [ :aPresenter | 
			(aPresenter instantiate: StComposedMethodElementPresenter)
				messageList: self;
				yourself ];
		bind: [ :aPresenter :anElement | aPresenter model: anElement ].
		
	listPresenter outputActivationPort transmitDo: [ :aMethod | self doBrowseMethod ].
	listPresenter actions: self methodListActions
]
