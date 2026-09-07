"
I wrap a RPackage entry, to modify its behavior if required for the class
"
Class {
	#name : 'StPackageEntry',
	#superclass : 'StEntry',
	#category : 'NewTools-Spotter-Entries',
	#package : 'NewTools-Spotter',
	#tag : 'Entries'
}

{ #category : 'spotter-extensions' }
StPackageEntry class >> prepareUnifiedHeaderDescriptionFor: aHeaderPresenter [

	^ aHeaderPresenter prepareAsPackages
]

{ #category : 'converting' }
StPackageEntry >> asHistoryEntry [

	^ StHistoryPackageEntry new: self
]

{ #category : 'accessing' }
StPackageEntry >> categoryLabel [

	^ 'package'
]

{ #category : 'printing' }
StPackageEntry >> displayStringOn: aStream [

	aStream nextPutAll: content name
]

{ #category : 'evaluating' }
StPackageEntry >> doEvaluate [

	content browse
]

{ #category : 'accessing' }
StPackageEntry >> iconName [

	^ #package
]

{ #category : 'spotter-extensions' }
StPackageEntry >> prepareUnifiedHeaderDescriptionFor: aHeaderPresenter [

	^ aHeaderPresenter prepareAsPackages
]
