Extension { #name : 'EpLog' }

{ #category : '*NewTools-Epicea' }
EpLog >> browseEvents [
	"Browse all events from my head."

	^ EpLogBrowserPresenter openWithLog: self
]

{ #category : '*NewTools-Epicea' }
EpLog >> browseVersionsOf: aMethod [
	"Browse all versions of aMethod from my head."

	^ (EpLogBrowserPresenter newWithLog: self)
			addFilter: (EpPluggableFilter isMethod: aMethod);
			refresh;
			open
]
