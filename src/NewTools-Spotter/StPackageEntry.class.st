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

{ #category : 'converting' }
StPackageEntry >> asString [

	^ content name
]

{ #category : 'accessing' }
StPackageEntry >> categoryLabel [

	^ 'package'
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
