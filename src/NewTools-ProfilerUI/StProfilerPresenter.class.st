"
I am a graphical user interface for profiling code using both AndreasProfiler and TimeProfiler
"
Class {
	#name : 'StProfilerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'inputPresenter',
		'resultsPresenter',
		'viewModel'
	],
	#category : 'NewTools-ProfilerUI-Presenters',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Presenters'
}

{ #category : 'examples' }
StProfilerPresenter class >> defaultPreferredExtent [ 
	^ 800 @ 800
]

{ #category : 'examples' }
StProfilerPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Profiler')
		parent: #Profiling;
		order: 1;
		iconName: #smallProfile;
		help: 'Profile the execution of a piece of code using different profilers, and navigate into the result.';
		action: [self new open]
]

{ #category : 'examples' }
StProfilerPresenter class >> open [

	<example>
	^ (self newApplication: StPharoApplication current) open
]

{ #category : 'spying' }
StProfilerPresenter class >> profileBlock: aBlock [

	^ self new
		  open;
		  profileBlock: aBlock;
		  yourself
]

{ #category : 'spying' }
StProfilerPresenter class >> profileCode: aString [

	^ self new
		  open;
		  profileCode: aString asString;
		  yourself
]

{ #category : 'layout' }
StProfilerPresenter >> defaultLayout [
	"If we open the presenter via the world menu, we display the input. If we open it programatically on a block, we do not display it."

	^ inputPresenter
		  ifNil: [
				  SpBoxLayout newTopToBottom
					  add: resultsPresenter;
					  yourself ]
		  ifNotNil: [
				  SpPanedLayout newTopToBottom
					  positionOfSlider: 20 percent;
					  add: inputPresenter;
					  add: resultsPresenter;
					  yourself ]
]

{ #category : 'private - factory' }
StProfilerPresenter >> disableInputPresenter [

	inputPresenter := nil
]

{ #category : 'initialization' }
StProfilerPresenter >> initializePresenters [

	super initializePresenters.
	inputPresenter := self instantiate: StProfilerInputPresenter on: self viewModel.
	resultsPresenter := self instantiate: StProfilerResultsPresenter on: self viewModel
]

{ #category : 'initialization' }
StProfilerPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenOpenedDo: [ self subscribe ];
		whenClosedDo: [ self unsubscribe ]
]

{ #category : 'private - factory' }
StProfilerPresenter >> newInputPresenter [

	^ StProfilerInputPresenter on: self viewModel
]

{ #category : 'actions' }
StProfilerPresenter >> profileBlock: aBlock [

	inputPresenter
		block: aBlock;
		profileIt
]

{ #category : 'actions' }
StProfilerPresenter >> profileBlock: aBlock displayCode: aString [

	inputPresenter
		block: aBlock;
		code: aString;
		profileIt
]

{ #category : 'actions' }
StProfilerPresenter >> profileCode: aString [

	inputPresenter
		code: aString;
		profileIt
]

{ #category : 'private - factory' }
StProfilerPresenter >> resultsPresenter: aPresenter [

	resultsPresenter := aPresenter
]

{ #category : 'subscription' }
StProfilerPresenter >> subscribe [

	resultsPresenter subscribeOnProfilingAnnouncements.
	inputPresenter ifNotNil: [ inputPresenter subscribeOnProfilingAnnouncements ]
]

{ #category : 'subscription' }
StProfilerPresenter >> unsubscribe [

	resultsPresenter unsubscribeFromProfilingAnnouncements.
	inputPresenter ifNotNil: [ inputPresenter unsubscribeFromProfilingAnnouncements ]
]

{ #category : 'accessing' }
StProfilerPresenter >> viewModel [

	^ viewModel ifNil: [ viewModel := StProfilerModel new ]
]

{ #category : 'accessing' }
StProfilerPresenter >> windowTitle [
	^ 'Profiler'
]
