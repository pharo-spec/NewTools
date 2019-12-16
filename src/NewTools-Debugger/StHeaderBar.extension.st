Extension { #name : #StHeaderBar }

{ #category : #'*NewTools-Debugger' }
StHeaderBar >> applyStyleToLabel: aStyleName [
	titleLabel addStyle: aStyleName
]

{ #category : #'*NewTools-Debugger' }
StHeaderBar >> removeStyleFromLabel: aStyleName [
	titleLabel removeStyle: aStyleName
]
