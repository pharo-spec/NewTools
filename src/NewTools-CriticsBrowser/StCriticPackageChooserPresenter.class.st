Class {
	#name : #StCriticPackageChooserPresenter,
	#superclass : #StPackageChooserPresenter,
	#instVars : [
		'packageActionBar',
		'testPackages'
	],
	#category : #'NewTools-CriticsBrowser'
}

{ #category : #initialization }
StCriticPackageChooserPresenter >> initialize [

	testPackages := false.
	super initialize
]

{ #category : #initialization }
StCriticPackageChooserPresenter >> initializeLayout [
	
	self layout: (SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpPanedLayout newLeftToRight
			add: (SpBoxLayout newLeftToRight
				spacing: 5;
				add: (SpBoxLayout newTopToBottom 
					add: (packageList := (self instantiate: SpFilteringSelectableListPresenter));
					addLast: (packageActionBar := SpBoxLayout newLeftToRight) expand: false;
					yourself);
				add: (buttonBar := SpBoxLayout newTopToBottom) expand: false;
				yourself);
			add: (selectedPackagesList := (self instantiate: SpFilteringSelectableListPresenter));
			yourself);
		yourself)
]

{ #category : #initialization }
StCriticPackageChooserPresenter >> initializePackageList [

	super initializePackageList.
	packageActionBar add: (self newToggleButton
		label: 'Include tests'; 
		help: 'Toggle showing of test packages';
		state: self withTestPackages;
		whenChangedDo: [ :state | self testPackages: state ];		
		yourself)
]

{ #category : #accessing }
StCriticPackageChooserPresenter >> packages [
	| packages |

	packages := super packages.
	^ self withTestPackages
			ifTrue: [ packages ]
			ifFalse: [ self removeTestPackagesFrom: packages ]
]

{ #category : #private }
StCriticPackageChooserPresenter >> removeTestPackagesFrom: aCollectionOfPackages [
	| regex |

	regex := '.*Test.*' asRegex.
	^ aCollectionOfPackages reject: [ :each | regex matches: each packageName ]

	
]

{ #category : #private }
StCriticPackageChooserPresenter >> testPackages: aBoolean [ 

	testPackages := aBoolean.
	aBoolean ifFalse: [ 
		packageList selectItems: (self removeTestPackagesFrom: packageList selectedItems) ].
	self updatePresenter
]

{ #category : #initialization }
StCriticPackageChooserPresenter >> withTestPackages [

	^ testPackages
]
