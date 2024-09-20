"
Implements global settings for the Finder tool.

See class side for details.
"
Class {
	#name : 'StFinderSettings',
	#superclass : 'Object',
	#classVars : [
		'CleanResultsOnEmptyInput',
		'EvaluationTimeout',
		'ExcludeTests',
		'ExpandResults',
		'IgnoreComments',
		'LogErrorFile',
		'LogErrorsToFile',
		'LogErrorsToTranscript',
		'SearchAsYouType',
		'UseCompletion'
	],
	#category : 'NewTools-Finder-Core',
	#package : 'NewTools-Finder',
	#tag : 'Core'
}

{ #category : 'system settings' }
StFinderSettings class >> cleanResultsOnEmptyInput [
	"Modified by settings Finder: self classSide >> #cleanResultsOnEmptyInputOn:"

	^ CleanResultsOnEmptyInput
		ifNil: [ CleanResultsOnEmptyInput := false ]
]

{ #category : 'system settings' }
StFinderSettings class >> cleanResultsOnEmptyInput: aBoolean [
	"Modified by settings Finder: self classSide >> #cleanResultsOnEmptyInputOn:"

	CleanResultsOnEmptyInput := aBoolean
]

{ #category : 'system settings' }
StFinderSettings class >> cleanResultsOnEmptyInputOn: aBuilder [
	<systemsettings>
	
	(aBuilder setting: #cleanResultsOnEmptyInput)
		parent: #finder;
		default: false;
		label: 'Clean results on clean text input';
		description: 'Clean results after text input is cleaned';
		target: self
]

{ #category : 'system settings' }
StFinderSettings class >> evaluationTimeout [
	"Modified by settings Finder: self classSide >> #evaluationTimeoutOn:"

	^ EvaluationTimeout
		ifNil: [ EvaluationTimeout := 5000 ]
]

{ #category : 'system settings' }
StFinderSettings class >> evaluationTimeout: aNumber [
	"Modified by settings Finder: self classSide >> #evaluationTimeoutOn:"

	EvaluationTimeout := aNumber
]

{ #category : 'system settings' }
StFinderSettings class >> evaluationTimeoutOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #evaluationTimeout)
		parent: #finder;
		default: 500;
		label: 'Evaluation timeout';
		description: 'Maximum timeout delay for individual calls in Examples search. Expects an integer giving the number of miliseconds.
		
Setting a value of 0 will set the evaluation to run without timeout';
		target: self
]

{ #category : 'system settings' }
StFinderSettings class >> excludeTests [
	"Modified by settings Finder: self classSide >> #logErrorsToTranscriptOn:"

	^ ExcludeTests
		ifNil: [ ExcludeTests := false ]
]

{ #category : 'system settings' }
StFinderSettings class >> expandResults [
	"Modified by settings Finder: self classSide >> #logErrorsToTranscriptOn:"

	^ ExpandResults
		ifNil: [ ExpandResults := false ]
]

{ #category : 'system settings' }
StFinderSettings class >> expandResults: aBoolean [ 

	ExpandResults := aBoolean
]

{ #category : 'system settings' }
StFinderSettings class >> expandResultsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #expandResults)
		parent: #finder;
		default: false;
		label: 'Expand all results by default';
		description: 'All results with children will be expanded if true';
		target: self
]

{ #category : 'system settings' }
StFinderSettings class >> groupSettingsOn: aBuilder [
	<systemsettings>

	(aBuilder group: #finder)
		label: 'Finder';
		description: '';
		parent: #tools
]

{ #category : 'system settings' }
StFinderSettings class >> ignoreComments [
	"Modified by settings Finder: self classSide >> #logErrorsToTranscriptOn:"

	^ IgnoreComments
		ifNil: [ IgnoreComments := true ]
]

{ #category : 'system settings' }
StFinderSettings class >> logErrorFile [
	"Modified by settings Finder: self classSide >> #logErrorsToTranscriptOn:"

	^ LogErrorFile
		ifNil: [ LogErrorFile := '' ]
]

{ #category : 'system settings' }
StFinderSettings class >> logErrorFileReference [
	"Answer a <FileReference> used to log evaluation errors"

	^ self logErrorFile asFileReference
]

{ #category : 'system settings' }
StFinderSettings class >> logErrorsToFile [
	"Answer <true> if the receiver should log errors to a file"

	^ LogErrorsToFile 
		ifNil: [ LogErrorFile := false ]
]

{ #category : 'system settings' }
StFinderSettings class >> logErrorsToFile: aBoolean [ 

	LogErrorFile := aBoolean 
]

{ #category : 'system settings' }
StFinderSettings class >> logErrorsToFileOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #logErrorsToFile)
		parent: #finder;
		default: false;
		label: 'Log errors to file';
		description: 'Log evaluation errors in the examples search to a file';
		target: self
]

{ #category : 'system settings' }
StFinderSettings class >> logErrorsToTranscript [
	"Modified by settings Finder: self classSide >> #logErrorsToTranscriptOn:"

	^ LogErrorsToTranscript
		ifNil: [ LogErrorsToTranscript := false ]
]

{ #category : 'system settings' }
StFinderSettings class >> logErrorsToTranscript: aBoolean [ 

	LogErrorsToTranscript := aBoolean
]

{ #category : 'system settings' }
StFinderSettings class >> logErrorsToTranscriptOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #logErrorsToTranscript)
		parent: #finder;
		default: false;
		label: 'Log errors to Transcript';
		description: 'Log evaluation errors in the examples search to the Transcript';
		target: self
]

{ #category : 'system settings' }
StFinderSettings class >> searchAsYouType [
	"Modified by settings Finder: self classSide >> #searchAsYouTypeOn:"

	^ SearchAsYouType
		ifNil: [ SearchAsYouType := false ]
]

{ #category : 'system settings' }
StFinderSettings class >> searchAsYouType: aBoolean [
	"Modified by settings Finder: self classSide >> #searchAsYouTypeOn:"

	SearchAsYouType := aBoolean
]

{ #category : 'system settings' }
StFinderSettings class >> searchAsYouTypeOn: aBuilder [
	<systemsettings>
	
	(aBuilder setting: #searchAsYouType)
		parent: #finder;
		default: false;
		label: 'Search as you type';
		description: 'Present results as you type';
		target: self
]

{ #category : 'system settings' }
StFinderSettings class >> useCompletion [
	"Modified by settings Finder: self classSide >> #useCompletionOn:"

	^ UseCompletion
		ifNil: [ UseCompletion := false ]
]

{ #category : 'system settings' }
StFinderSettings class >> useCompletion: aBoolean [ 

	UseCompletion := aBoolean
]

{ #category : 'system settings' }
StFinderSettings class >> useCompletionOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #useCompletion)
		parent: #finder;
		default: false;
		label: 'Use completion';
		description: 'Enable or disable autocompletion in finder text field as you type';
		target: self
]
