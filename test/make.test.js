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
			try{
				smartId.make({
					length: -1
				});
			}
			catch (err){
				err.should.be.an.Error;
			}
		});
	});
});