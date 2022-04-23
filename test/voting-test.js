const { expect, assert } = require("chai");
const { ethers } = require("hardhat");


describe("Voting", () => {
  let voting;
  before(async () => {
    const Voting = await ethers.getContractFactory("Voting");
    voting = await Voting.deploy();

  })

  //ADD CANDIDATE
  describe("addCandidate", () => {
    it("Add candidate for election", async () => {
      await voting.deployed();
      //candidate  added
      await voting.addCandidate("Harry")
      assert(true);
    })

    it("can't add one candidate multiple times", async () => {
      await voting.deployed();


      try {
        await voting.addCandidate("Harry");
        assert(false)
      } catch (error) {
        assert(error)
      }
    })
  })

  //CAST VOTE
  describe("vote", function () {
    it("cannot vote when voting is disabled", async function () {
      await voting.deployed();
      try {
      //disable voting
      //try voting
        await voting.disableVoting();
        await voting.vote(0)
        assert(false);
      } catch (error) {
        assert(error)
      }
    });

    it("increment candidates vote by 1", async function () {

      await voting.deployed();

      //enable voting
      await voting.enableVoting();
      await voting.vote(0);

      assert(true)
    });

    it("Voters can only vote once", async function () {
      await voting.deployed();
      try {

        await voting.vote(0);
        assert(false);
      } catch (error) {
        assert(error)
      }


    });

    it("Voters can vote for only one candidate", async function () {

      await voting.deployed();
      try {
        //adding another candidate
        //try voting for new candidate
        await voting.addCandidate("test")
        await voting.vote(1);
        assert(false);
      } catch (error) {
        assert(error)
      }
    });



  });


  //GET ALL CANDIDATES
  describe("getAllCandidates", function () {

    it("Should return names and ids of candidates", async function () {

      await voting.deployed();

      //get the candidates
      const candidate = await voting.getAllCandidates();


      expect(await candidate[0][0]).to.equal("Harry");
    });
  });


  //GETS ALL RESULT
  describe("compile Result", function () {
    it("Should return names and votecounts", async function () {
      await voting.deployed();

      //add more candidates

      await voting.addCandidate("demo")

      const result = await voting.compileResult();

      //test for the values
      expect(await result[0][0]).to.equal("Harry");
      expect(await result[1][0].toNumber()).to.equal(1);
      expect(await result[0][1]).to.equal("test");
      expect(await result[1][1].toNumber()).to.equal(0);
      expect(await result[0][2]).to.equal("demo");
      expect(await result[1][2].toNumber()).to.equal(0);
    });
  });
   

  //Enable voting
  describe("enable voting", function () {
    it("Should enable voting for user", async function (){
      await voting.deployed();
      assert(true)

      //enable vote
      const enable = await voting.enableVoting();

      expect(await enable[0][0]).to.equal("kehinde");
    });
  });
  

    //Disable voting
    describe("disable voting", function () {
      it("Should disable voting for user", async function (){
        await voting.deployed();
        assert(false)
  
        //enable vote
        const disable = await voting.disableVoting();
  
        expect(await disable[0][0]).to.equal("kehinde");
      });
    });

})