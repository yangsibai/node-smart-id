/**
 * Created by massimo on 14-9-23.
 */

should = require("should");
smartId = require("../lib/index.js");

describe("smart-id make id test", function () {
	describe("length test", function () {
		it("omit options should make a length of 10 random id", function () {
			id = smartId.make();
			id.should.have.lengthOf(10);
		});
		it("set length of 6 should make a length of 6 id", function () {
			id = smartId.make({
				length: 6
			});
			id.should.have.a.lengthOf(6);
		});
		it("set length of negative should throw a error", function () {
			smartId.make.bind(null, {
				length: -1
			}).should.throw();
		});
		it("set length of zero should not throw a error and have a leng of 10", function () {
			smartId.make.bind(null, {
				length: 0
			}).should.not.throw();
			id = smartId.make({
				length: 10
			});
			id.should.have.lengthOf(10);
		});
	});
	describe("mode test", function () {
		it("omit options.mode should make a random id with all characters", function () {
			randomStr = longRandomId();
			_containLower(randomStr).should.be.true;
			_containUpper(randomStr).should.be.true;
			_containNumber(randomStr).should.be.true;
		});
		it("mode 'a' should only use lower case characters", function () {
			randomStr = longRandomId("a");
			_containLower(randomStr).should.be.true;
			_containUpper(randomStr).should.be.false;
			_containNumber(randomStr).should.be.false;
		});
		it("mode 'A' should only use upper characters", function () {
			randomStr = longRandomId("A");
			_containLower(randomStr).should.be.false;
			_containUpper(randomStr).should.be.true;
			_containNumber(randomStr).should.be.false;
		});
		it("mode '0' should only use number characters", function () {
			randomStr = longRandomId("0");
			_containLower(randomStr).should.be.false;
			_containUpper(randomStr).should.be.false;
			_containNumber(randomStr).should.be.true;
		});
		it("mode 'aA' should use all characters", function() {
			randomStr = longRandomId("aA");
			_containLower(randomStr).should.be.true;
			_containUpper(randomStr).should.be.true;
			_containNumber(randomStr).should.be.false;
		});
	});
});


function longRandomId(mode) {
	randomStr = "";
	for (var i = 0; i < 1000; i++) {
		randomStr += smartId.make({
			mode: mode
		});
	}
	return randomStr;
}


_containLower = function (input) {
	return /[a-z]/.test(input);
};

_containUpper = function (input) {
	return /[A-Z]/.test(input);
};

_containNumber = function (input) {
	return /\d/.test(input);
};