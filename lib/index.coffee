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
    @return {String} random string
###
exports.make = (options)->
	defaultOptions =
		mode: "aA0"
		length: 10

	if options
		for k, v of options
			defaultOptions[k] = v if v

	throw new Error("length should be a positive number") if defaultOptions.length <= 0
	throw new Error("mode should not be empty") unless defaultOptions.mode

	condidates = getCondidates(defaultOptions.mode)
	return generateRandomStr(condidates, defaultOptions.length)

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