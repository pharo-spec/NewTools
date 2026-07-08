Extension { #name : 'AndreasSystemProfiler' }

{ #category : '*NewTools-ProfilerUI' }
AndreasSystemProfiler >> open [

	| resultsPresenter profilerModel profilerPresenter |
	profilerModel := StProfilerModel new
		profiler: self;
		yourself.
	profilerModel setTallyRoot: (self tallyRoot asTallyModel
			model: profilerModel;
			yourself).
	resultsPresenter :=( StProfilerResultsPresenter on: profilerModel)
		handleProfilingFinished;
		yourself.

	profilerPresenter := StProfilerPresenter new
		resultsPresenter: resultsPresenter;
		disableInputPresenter;
		yourself.
	^ profilerPresenter open
]
