const KyberQuick = artifacts.require("KyberQuick");

module.exports = function(deployer) {
  deployer.deploy(KyberQuick, "0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359");
};
