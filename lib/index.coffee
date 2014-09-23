_ = require("underscore")

lower = "abcdefghijklmnopqrstuvwxyz"
lowerSmart = "abcdefghjkmnpqrstuvwxyz"

upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
upperSmart = "ABCDEFGHJKMNPRSTUVWXY"

number = "0123456789"
numberSmart = "3456789"

###
    generate id
    @param {Object} [options]
    @param {String} [options.mode = "aA0"] mode: 0 = 0 ~ 9, a = a ~ z, A = A ~ Z, s = smart, other characters = add these characters in candidate
    @param {Number} [options.length = 10]
    @param {Function} [options.verify] verify random id
    @param {Function} [options.retry = 3] retry times
    @param {Function} [cb] callback function
    @return {String} random string
###
exports.make = (options, cb)->
	defaultOptions =
		mode: "aA0"
		length: 10
		verify: null
		retry: 1

	isSync = true
	if arguments.length is 1
		if _.isFunction(options)
			isSync = false
			cb = options
		else
			for k, v of options
				defaultOptions[k] = v if v
	else if arguments.length is 2
		isSync = false
		for k, v of options
			defaultOptions[k] = v if v

	if isSync
		throw new Error("length should be a positive number") if defaultOptions.length <= 0
		throw new Error("mode should not be empty") unless defaultOptions.mode
	else
		return cb(new Error("length should be a positive number")) if defaultOptions.length <= 0
		return cb(new Error("mode should not be empty")) unless defaultOptions.mode

	condidates = getCondidates(defaultOptions.mode)

	unless defaultOptions.verify
		id = generateRandomStr(condidates, defaultOptions.length)
		if isSync
			return id
		else
			cb(id)
	else if defaultOptions.length is 1
		id = tryGenerate(defaultOptions, condidates)
		return id
	else if defaultOptions.length is 2
		tryGenerateASync defaultOptions, condidates, cb

tryGenerate = (options, condidates)->
	for i in [1..options.retry]
		id = generateRandomStr(condidates, options.length)
		return id if (not _.isFunction(options.verify)) or options.verify(id)
	throw new Error("can't get a valid random id in #{options.retry} times")

tryGenerateASync = (options, condidates, cb)->
	if options.length <= 0
		cb(new Error("can't get a valid random id in #{options.retry} times"))
	else
		options.length--
		id = generateRandomStr(condidates, options.length)
		options.verify id, (err, success)->
			return cb(err) if err
			return cb(null, id) if success
			tryGenerateASync(options, condidates, cb)

###
    get condidates characters
    @param {String} mode
    @return {String} condidate characters
###
getCondidates = (mode)->
	isSmart = "s" in mode
	characters = ""
	for c in mode
		switch c
			when "a"
				characters += (if isSmart then lowerSmart else lower)
			when "A"
				characters += (if isSmart then upperSmart else upper)
			when "0"
				characters += (if isSmart then numberSmart else number)
			else
				characters += c
	return characters

###
    generate a random string
    @param {String} condidateChars
    @param {Number} length
    @return {String} random string
###
generateRandomStr = (condidateChars, length)->
	randomStr = ""
	for i in [1..length]
		randomStr += condidateChars[~~(Math.random() * condidateChars.length)]
	return randomStr